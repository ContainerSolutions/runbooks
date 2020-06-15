---
title: "DNS Lookup Delay"
summary: "Delay in DNS server response"
draft: true
---

## Overview {#overview}

This issue happens when your application pauses a significant period of time when doing a DNS lookup.

## Check RunBook Match {#check-runbook-match}

If your application regularly pauses when doing anything on the network, but succesfully continues, this runbook may help.

## Initial Steps Overview {#initial-steps-overview}

1) [Gather information](#step-1)

2) [Run lookup on the command line](#step-2)

3) [Subset of URLs?](#step-3)

4) [Using DNSMasq?] (#step-4)

5) [IPTables?](#step-5)

## Detailed Steps {#detailed-steps}

### 1) Gather information {#step-1}

#### 1.1) Operating system {#step-1-1}

First, determine which OS you are running. See the [Determine Operating System How-To ]({{< relref "../how-to/determine-operating-system.md" >}})

#### 1.2) DNS servers {#step1-2}

Next, determine which DNS servers you are using.

If your OS is `Darwin`/Mac/iOS, then run

```
scutil --dns > /tmp/runbooks-dns-servers.txt
```

and capture the output.

If your OS is `Linux`, then run:

```
cat /etc/resolv.conf | grep ^nameserver > /tmp/runbooks-dns-servers.txt
```

If your nameservers are

#### 1.3) Get host you are trying to look up {#step1-3}

You may need to get this from your application logs.

If you can't work this out,  just use a 'standard' one, like `google.com`.

This domain will be referred to as `[DOMAIN]` from here on.

#### 1.4) Figure Out When This Started {#step1-4}

If this behaviour was not always

#### 1.5) How widespread is the problem {#step1-5}

If you can, determine whether this affects *all* DNS lookups or just a subset.

If it's just a subset, then you may want to skip to [Step 3](#step-3)

#### 1.5) Are you running a DNS proxy? {#step1-5}

TODO: Background on DNS proxy

- Are you running DNSMasq? Running this may help determine that:

```
ps -ef | grep -i dnsmasq
```

- Vagrant landrush?

TODO

- Others?

Try connecting to localhost 53 with telnet

### 2) Run lookup on the command line {#step-2}

### 2.1) Reproduce problem on the command line {#step-2-1}

First, try and reproduce the problem by running a lookup on your machine

```
dig [DOMAIN]
```

If you can't reproduce the problem, then it may be that your application is using a different DNS lookup method than your host does.

### 2.2) Run lookup against each nameserver in turn {#step-2-2}

Then, do the same lookup on each nameserver you extracted from [step 1.2](#step-1-2).

```
dig @1.2.3.4 [DOMAIN]
```

If one of the nameservers is delayed, and the others are fast, consider moving to [Solution A](#solution-a)

### 2.2) Run lookup against a well known DNS server {#step-2-2}

Use a well-known public DNS server, for example Google's `8.8.8.8`:

```
dig @8.8.8.8 [DOMAIN]
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

```
IGNORE_RESOLVCONF=yes
```

#### 4.2) `/etc/resolv.conf` DNSMasq Config {#step-4-2}

```
[...]
nameserver [...]

restart dnsmasq
```

#### 4.3) Check DNSMasq logs {#step-4-3}

This may give a clue as to where the issue lies.

TODO: more guidance here?

#### 4.4) Further information {#step-4-4}

See below for more background that may help, and in [further information](#further-information):

[Possible layers involved, along with systemd](https://unix.stackexchange.com/posts/418180/revisions)

### 5) IPTables? {#step-5}

It may be possible that IPTables is interfering with your DNS request somehow.

TODO: guidance here

## Solutions List {#solutions-list}

A) [Edit the nameserver list](#solution-a)

## Solution Detail {#solution-detail}

### A) Edit the nameserver list {#solution-a}

If you are using Linux, then this is likely to be in `/etc/resolv.conf`.

If you are using Mac/iOS, then (?TODO?)

## Check Resolution {#check-resolution}

Your application should no longer be pausing on DNS lookups.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Network MTUs](https://en.wikipedia.org/wiki/Maximum_transmission_unit)

[DNSMasq Documentation](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html)

[RFC1035 - Domain Names - Implementation and Specification](https://tools.ietf.org/html/rfc1035)

[DNSMasq layers](https://unix.stackexchange.com/posts/418180/revisions)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (https://www.math.tamu.edu/~comech/tools/linux-slow-dns-lookup/ TODO)
[//]: # (https://wp-rocket.me/blog/test-dns-server-response-time-troubleshoot-site-speed/ TODO)
[//]: # (https://askubuntu.com/questions/1041526/very-slow-dns-lookup TODO)
[//]: # (https://stackoverflow.com/questions/11025953/why-does-my-dns-lookup-and-connect-take-over-2-seconds-57-of-page-load-tim TODO)
[//]: # (https://github.com/kubernetes/kubernetes/issues/56903 TODO)
[//]: # (https://kb.vmware.com/s/article/2070192 TODO)
[//]: # (https://openvpn.net/vpn-server-resources/troubleshooting-dns-resolution-problems/ TODO)
[//]: # (DNSMasq bug we saw - bind-interface)
[//]: # ()
