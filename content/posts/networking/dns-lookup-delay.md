---
title: "DNS Lookup Delay"
summary: "Delay in DNS server response"
---

## Overview {#overview}

This issue happens when your application pauses a significant period of time when doing a DNS lookup.

## Check RunBook Match {#check-runbook-match}

If your application regularly pauses when doing anything on the network, but successfully continues, this runbook may help.

## Initial Steps Overview {#initial-steps-overview}

1) [Gather information](#step-1)

2) [Run lookup on the command line](#step-2)

3) [Subset of URLs?](#step-3)

4) [Using DNSMasq?](#step-4)

5) [IPTables?](#step-5)

6) [IPv6 issue?](#step-6)

## Detailed Steps {#detailed-steps}

### 1) Gather information {#step-1}

#### 1.1) Operating system {#step-1-1}

First, determine which OS you are running. See the [Determine Operating System How-To ]({{< relref "../how-to/determine-operating-system.md" >}})

#### 1.2) DNS servers {#step1-2}

Next, determine which DNS servers you are using.

If your OS is `Darwin`/Mac/iOS, then run

```shell
scutil --dns > /tmp/runbooks-dns-servers.txt
```

and capture the output.

If your OS is `Linux`, then run:

```shell
cat /etc/resolv.conf | grep ^nameserver > /tmp/runbooks-dns-servers.txt
```

#### 1.3) Get host you are trying to look up {#step1-3}

You may need to get this from your application logs.

If you can't work this out,  just use a 'standard' one, like `google.com`.

This domain will be referred to as `[DOMAIN]` from here on.

#### 1.4) Figure Out When This Started {#step1-4}

If this behaviour was not always happening on this host, then try and work out when it started.

#### 1.5) How widespread is the problem {#step1-5}

If you can, determine whether this affects *all* DNS lookups or just a subset.

If it's just a subset, then you may want to skip to [Step 3](#step-3)

#### 1.5) Are you running a DNS proxy? {#step1-5}

A DNS proxy is a program that intercepts DNS requests and replies to DNS requests, or passes them on to other DNS servers. Sometimes these run as local services on the host making the request, to

##### 1.5.1) Use `netstat` {#step1-5-1}

First try connecting to localhost on port 53 (the standard DNS port) with `netstat`, eg if you run:

```shell
netstat -l | grep -w 53
```

and get a response that contains a line like:

```
udp        0      0 127.0.0.53:domain       0.0.0.0:*
```

then you have a server running on the DNS port on your local machine.

If you have suspicions that a DNS proxy may be running on your host, then running the same command without `grep`'s `-w` flag may help. Many DNS proxies have `53` somewhere in their port number (eg see [Vagrant landrush](#step1-5-3), below).

##### 1.5.2) DNSMasq? {#step1-5-2}

- Are you running DNSMasq? Running this may help determine that:

```shell
ps -ef | grep -i dnsmasq
```

##### 1.5.3) Vagrant landrush? {#step1-5-3}

[Vagrant landrush](https://github.com/vagrant-landrush/landrush) is another DNS proxy that can 'take over' your DNS requests. It uses IPTables to divert DNS requests on the host to port 53 to itself. If Landrush can't reply, then it passes the request on to its original destination.

It uses port `10053`.

##### 1.5.4) Kubernetes? {#step1-5-4}

TODO

##### 1.5.5) `systemd-resolved`? {#step1-5-5}

It uses port `10053`.

### 2) Run lookup on the command line {#step-2}

#### 2.1) Reproduce problem on the command line {#step-2-1}

First, try and reproduce the problem by running a lookup on your machine, using `time` to get a report of the time taken, and `dig` to do the lookup itself:

```shell
time dig [DOMAIN]
```

If you can't reproduce the problem, then it may be that your application is using a different DNS lookup method than your host does.

#### 2.2) Run lookup against each nameserver in turn {#step-2-2}

Then, do the same lookup on each nameserver you extracted from [step 1.2](#step-1-2).

```shell
time dig @1.2.3.4 [DOMAIN]
```

If one of the nameservers is delayed, and the others are fast, consider moving to [Solution A](#solution-a)

#### 2.3) Run lookup against a well known DNS server {#step-2-3}

Use a well-known public DNS server, for example Google's `8.8.8.8`:

```shell
time dig @8.8.8.8 [DOMAIN]
```

to check whether the issue is with the nameservers you are using.

### 3) Subset of URLs? {#step-3}

If this issue affects a subset of URLs, then consider:

- do the affected domains return a large DNS response?

If so, then you may be hitting limits on the size of the DNS response, which in turn trigger [network MTUs](https://en.wikipedia.org/wiki/Maximum_transmission_unit) limits, or exceed the RFC length of DNS responses (see size limits [here](https://tools.ietf.org/html/rfc1035)).

This has been seen when enterprises have

### 4) Using DNSMasq? {#step-4}

If you are using DNSMasq (a popular local DNS server), consider:

#### 4.1) DNSMasq config {#step-4-1}

- whether DNSMasq could be causing the problem. Config to consider includes:

```shell
IGNORE_RESOLVCONF=yes
```

#### 4.2) `/etc/resolv.conf` DNSMasq Config {#step-4-2}

```shell
[...]
nameserver [...]

restart dnsmasq
```

#### 4.3) Check DNSMasq logs {#step-4-3}

This may give a clue as to where the issue lies.

Typically, this will involve running (as root):

```shell
journalctl -u dnsmasq
```

#### 4.4) Further information {#step-4-4}

See below for more background that may help, and in [further information](#further-information):

[Possible layers involved, along with systemd](https://unix.stackexchange.com/posts/418180/revisions)

### 5) IPTables/NetFilter? {#step-5}

It may be possible that IPTables/NetFilter is interfering with your DNS request somehow.

See the [DNS lookup failure article step]({{< relref "dns-lookup-failure.md#step-4" >}}) for more guidance.

### 6) IPv6 issue? {#step-6}

If there is no delay when running

```shell
host [DOMAIN]
```

then the issue may be related to IPv6. See [solution C](#solution-c).

## Solutions List {#solutions-list}

A) [Edit the nameserver list](#solution-a)

B) [Reduce the timeout](#solution-b)

C) [Disable IPv6](#solution-c)

## Solution Detail {#solution-detail}

### A) Edit the nameserver list {#solution-a}

If you are using Linux, then this is likely to be in `/etc/resolv.conf`.

Please be aware of [systemd](#further-information-systemd-resolved) when editing `/etc/resolv.conf`. It is possible that changes to this file will be overwritten.

If you are using Mac/iOS, then (?TODO?)

### B) Reduce the timeout {#solution-b}

This is less of a solution than a workaround, since it masks the problem. It may help to confirm whether the delay is due to a problem with a specific DNS server among others.

If you add the line `options timeout:1` to your `/etc/resolv.conf` file and see the delay fall to 1 second, then the issue is likely to be with a specific DNS server in your list.

### C) Disable IPv6 {#solution-c}

Before applying this solution, be aware that switching off IPv6 may not be advisable if you are using it.

If you run this as root, then IPv6 will be disabled.

```shell
sysctl net.ipv6.conf.all.disable_ipv6=1
```

TODO: persisting this?

## Check Resolution {#check-resolution}

Your application should no longer be pausing on DNS lookups.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

### Links {#further-information-links}

[Network MTUs](https://en.wikipedia.org/wiki/Maximum_transmission_unit)

[DNSMasq Documentation](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html)

[RFC1035 - Domain Names - Implementation and Specification](https://tools.ietf.org/html/rfc1035)

[DNSMasq layers](https://unix.stackexchange.com/posts/418180/revisions)

### `systemd-resolved` and `/etc/resolv.conf` {#further-information-systemd-resolved}

Systemd has made DNS configuration a lot more complicated in recent years.

There are two systemd services associated with DNS resolution.

`systemd-resolved.service`

`resolvconf.service`

TODO: more on this, and advice on how to update your configuration

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (https://askubuntu.com/questions/1041526/very-slow-dns-lookup DONE)
[//]: # (https://github.com/kubernetes/kubernetes/issues/56903 TODO)
[//]: # (https://kb.vmware.com/s/article/2070192 DONE)
[//]: # (https://openvpn.net/vpn-server-resources/troubleshooting-dns-resolution-problems/ DONE)
[//]: # (https://stackoverflow.com/questions/11025953/why-does-my-dns-lookup-and-connect-take-over-2-seconds-57-of-page-load-tim DONE)
[//]: # (https://wp-rocket.me/blog/test-dns-server-response-time-troubleshoot-site-speed/ DONE)
[//]: # (https://www.math.tamu.edu/~comech/tools/linux-slow-dns-lookup/ DONE)
[//]: # (DNSMasq bug we saw - bind-interface)
[//]: # ()
