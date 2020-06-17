---
title: "DNS Lookup Failure"
summary: "DNS Request Fails"
---

## Overview {#overview}

This issue happens when a DNS lookup is performed on a Linux system, and an IP address is not returned.

## Check RunBook Match {#check-runbook-match}

If your application is pausing when a network request happens, this runbook may be a match.

This failure might be intermittent (due to caching of DNS responses in the application), or consistent.

If the DNS response is _delayed_, but returns a correct IP address see the [DNS lookup delay]({{< relref "dns-lookup-delay.md" >}}) runbook.

This runbook assumes you are on a Linux machine.

## Initial Steps Overview {#initial-steps-overview}

1) [Determine whether the Internet is accessible](#step-1)

2) [Determine whether all DNS lookups are failing](#step-2)

3) [Determine DNS lookup method](#step-3)

4) [Check IPTables](#step-4)

5) [Find Local DNS Server](#step-5)

## Detailed Steps {#detailed-steps}

### 1) Determine whether the Internet is accessible {#step-1}

First, check whether you have internet access at all. Surprisingly often, this is the root cause.

To determine this without relying on DNS lookups, run:

```
ping -c1 8.8.8.8
```

If you see output similar to this:

```
64 bytes from 8.8.8.8: icmp_seq=0 ttl=116 time=13.681 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 13.681/13.681/13.681/0.000 ms
```

then you have internet access.

If you do not, then the root cause is that you don't.

### 2) Determine whether all DNS lookups are failing {#step-2}

Run a DNS lookup against a stable site:

```
dig google.com
```

The output should look similar to this:

```
Server:		192.168.1.25
Address:	192.168.1.254#53

Non-authoritative answer:
Name:	google.com
Address: 216.58.201.46
```

Now run this command:

```
dig @8.8.8.8 google.com
```

Compare the output of the two dig commands you just ran.

The first two numbers in the IP address in the last line (`216.58` in the above example output) should match in your output.

- If they match, then DNS lookup is working for at least some DNS entries.

- If they do not match, then DNS lookup is not working on your host.

Note the above outcome down as 'DNS not working for all' or 'DNS working for some', as it will be used later.

### 3) Determine DNS lookup method {#step-3}

There are numerous ways DNS lookups can be performed. We now need to gather some facts about your host to determine what is doing the DNS lookup.

#### 3.1) `nsswitch` config {#step-3-1}

Run this command:

```
grep ^hosts: /etc/nsswitch.conf
```

If you see the output:

```
grep: /etc/nsswitch.conf: No such file or directory
```

then **note that you are not using nsswitch.**

Otherwise you see output like this:

```
/etc/nsswitch.conf:hosts: files dns myhostname
```

**Note down the words after ''hosts:'' as your 'nsswitch methods'**

#### 3.2) `nsswitch` host: `/etc/hosts` {#step-3-2}

If you are using nsswitch, and if `host` was in your `nsswitch methods`, then check whether the host that's failing is in your `/etc/hosts` file.

If it is, then go to [Solution A](#solution-a) and edit your `/etc/hosts` file.

#### 3.3) `nsswitch` dns: `/resolv.conf` {#step-3-3}

If you are using nsswitch, and `dns` **was not** in your 'nsswitch methods' then its absence may be the problem. Try adding it to see if that resolves your issue.

If you are using nsswitch, and `dns` **was** in your 'nsswitch methods', then run this command:

```
grep ^nameserver /etc/resolv.conf
```

**Note the output as 'dns servers in resolv.conf' in the order they are seen in the ''/etc/resolv.conf'' file.**

#### 3.4) Check Nameserver {#step-3-4}

For the first item in your 'dns servers in resolv.conf' list, determine:

- Is your DNS server IP address ('DNSSIPA') pointed to the localhost network?

- Is your DNSSIPA pointed to your local network?

- Is your DNSSIPA pointed to the internet?

To determine the answer to the above, follow the instructions below:

- If the DNSSIPA matches: 127.0.0.x, where x is any number between 0 and 255, then your DNS server is running locally. Proceed to [Find local DNS server](#step-5)

- If your DNSSIPA is in any of the following ranges: ''10.0.0.0-10.255.255.255'', ''172.16.0.0-172.31.255.255'', or ''192.168.0.0-192.168.255.255'', then your DNSSIPA is pointed to a local network. Otherwise, it's likely to be pointed at an internet address. If you're still unsure run: ''dig +short @8.8.8.8 -x DNSSIPA'', where DNSSIPA should be replaced with the actual IP address. If the output is empty then the IPA is pointed to your local network. If it is not empty, then it is pointed to the internet.

- If your DNSSIPA is pointed at the internet, then proceed to the solution [here]({{< relref "dns-lookup-delay.md#solution-a" >}}). If that solution does not resolve, continue.

### 4) Check IPTables / Netfilter {#step-4}

Run this script:

```
iptables -vL -t filter | grep -E -w '(53|domain)'
iptables -vL -t nat | grep -E -w '(53|domain)'
iptables -vL -t mangle | grep -E -w '(53|domain)'
iptables -vL -t raw | grep -E -w '(53|domain)'
iptables -vL -t security | grep -E -w '(53|domain)
```

If this produces any output lines at all, it may be that IPTables/NetFilter is diverting the DNS request and causing the issue. Try going to [Solution B](#solution-b) to see if that works.

If you are unsure whether IPTables/NetFilter are in place at all on your system, see [here]({{< relref "../how-to/determine-using-iptables.md}}).

Your IPTables output might suggest that requests to port 53 are being diverted to another local DNS server (Vagrant's landrush plugin does this, for example). See the next step for more on this.

### 5) Find Local DNS Server {#step-5}

If you still have not discovered the cause, then it is possible you have a local DNS server that is intercepting requests and at fault.

**As root**, run:

```
lsof -i 4udp@127.0.0.1:53 | grep -v ^COMMAND | awk '{print $1}'
```

this will tell you if any program is responding to DNS requests.

If the output is:

- `dnsmasq`, then dnsmasq may be at fault

If you want to explore further, there may be other programs listening for UDP requests on your hosts. This command, *run as root* will show you these:

```
lsof -i 4udp@127.0.0.1 | grep -v ^COMMAND | awk '{print $1}'
```

## Solutions List {#solutions-list}

A) [Edit /etc/hosts](#solution-a)

B) [Disable IPTables](#solution-b)

C) [Change DNS Server in `/etc/resolv.conf`](#solution-c)

## Solutions Detail {#solutions-detail}

### Solution A) Edit `/etc/hosts` {#solution-a}

Comment out the identified entry in `/etc/hosts` and go to [Check Resolution](#check-resolution).

### Solution B) Disable `iptables` {#solution-b}

Use `systemctl disable` (or whichever method of disabling services exists on your system) to disable `iptables`.

If it works (see [Check Resolution](#check-resolution), then it may be that IPTables is redirecting your requests to a different location.

In this case, you will need to determine why this IPTables rule exists and fix accordingly. The fix will be context-dependent.

Examples of legitimate reasons for doing this include:

  * Vagrant plugins (eg Landrush: https://github.com/vagrant-landrush/landrush/blob/master/README.adoc)

### Solution C) Change DNS Server in `/etc/resolv.conf` {#solution-c}

As root, replace the IP address of the DNS server on the first line beginning `nameserver` with a public DNS server that is likely to be available, eg Google's DNS server on: `8.8.8.8`.

Then go to [Check Resolution](#check-resolution).

## Check Resolution {#check-resolution}

Try running `dig` or `curl` against any domains that caused issues before, eg

```
dig google.com
curl google.com
```

If they appear to work now, then retry your original application.

If your original application still fails, it may have cached the bad lookup. A restart of the application may help.

Whether this fully resolves your issue will depend on the intention behind the design of the network you run on. If you are not fully responsible for it, then you will need to take the information you have gathered here to whoever is responsible for it.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

DNS lookups on Linux can be painfully complicated.

This series of blog posts may help give context:

[Anatomy of a DNS Lookup - Part I](https://zwischenzugs.com/2018/06/08/anatomy-of-a-linux-dns-lookup-part-i/)

[Anatomy of a DNS Lookup - Part II](https://zwischenzugs.com/2018/06/18/anatomy-of-a-linux-dns-lookup-part-ii/)

[Anatomy of a DNS Lookup - Part III](https://zwischenzugs.com/2018/07/06/anatomy-of-a-linux-dns-lookup-part-iii/)

[Anatomy of a DNS Lookup - Part IV](https://zwischenzugs.com/2018/08/06/anatomy-of-a-linux-dns-lookup-part-iv/)

[Anatomy of a DNS Lookup - Part V](https://zwischenzugs.com/2018/09/13/anatomy-of-a-linux-dns-lookup-part-v-two-debug-nightmares/)

[//]: # (REFERENCED DOCS)
[//]: # (eg https://somestackoverflowpage)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)
