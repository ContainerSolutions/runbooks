---
title: "No Route to Host"
summary: "Errors that contain the phrase 'no route to host'"
draft: true
---

## Overview {#overview}

This issue happens when a network request is attempted

## Check RunBook Match {#check-runbook-match}

If you see the words `No route to host` or `EHOSTUNREACH` in an error message

This runbook is limited to Linux hosts, although some steps may help trigger productive investigations on other OSes.

## Initial Steps Overview {#initial-steps-overview}

1) [Gather information](#step-1)

2) [Is host up?](#step-2)

3) [Is the port open?](#step-3)

4) [Check IPTables / NetFilter](#step-4)

5) [Check routing tables](#step-5)

6) [Check intervening firewalls](#step-6)

## Detailed Steps {#detailed-steps}

### 1) Gather information {#step-1}

#### 1.1) Determine the host {#step-1-1}

Determine the host (or IP) you are trying to reach.

From here, this host will be referred to as `[HOST|IP]`.

#### 1.2) Determine the IP {#step-1-2}

Once you have the hostname, then you can determine the IP address by running:

```shell
host [HOST]
```

which outputs, eg:

```
bbc.co.uk has address 151.101.0.81
bbc.co.uk has address 151.101.128.81
bbc.co.uk has address 151.101.64.81
bbc.co.uk has address 151.101.192.81
[...]
```

You can take the first address returned as the IP to use, eg for the above output, `151.101.0.81` would be the IP.

If you can find out the 'correct' IP that you are trying to reach by some means independent from your machine, do so. This might involve contacting another user, or figuring out the IP address by introspecting on the host.

TODO: HOW-TO work out my host's IP?

#### 1.3) Determine the port {#step-1-3}

Determine the port you are trying to reach.

If this is a 'standard' web request, then the port is either 80 (for http requests) or 443 (for https requests).

If the web request hits a non-standard port, then you will see `:[NUMBER]` in the URL, eg:

```
https://example.com:8443/path/to/site
```

would mean you are trying to contact port `8443`.

This will be referred to subsequently as `[PORT]`.

#### 1.4) Determine the frequency of the problem {#step-1-4}

Try and work out if the problem happens every time, or is intermittent.

If it's intermittent, consider whether there are multiple hosts that could be ultimately reached by the request (eg behind a load balancer), and whether one of these hosts is faulty.

### 2) Is host up? {#step-2}

### 2.1) Use nmap {#step-2-1}

Check whether the host you are trying to reach is up.

Run:

```shell
nmap [HOST|IP]
```

If you see output that begins like this:

```
Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-19 10:11 BST
```

then you have `nmap` installed. If you don't then you will need to install it. Wait for the command to return.

If you see a message in output like:

```
Failed to resolve "[HOST|IP]".
```

then this is a DNS lookup failure. See the [DNS Lookup Failure]({{< relref "dns-lookup-failure.md" >}}) runbook.

If you see output that mentions `Host is up`, like this:

```
Nmap scan report for bbc.com (151.101.128.81)
Host is up (0.016s latency).
Other addresses for bbc.com (not scanned): 151.101.64.81 151.101.192.81 151.101.0.81
Not shown: 998 filtered ports
PORT    STATE SERVICE
80/tcp  open  http
443/tcp open  https

Nmap done: 1 IP address (1 host up) scanned in 11.20 seconds
```

then the host you are trying to contact is up.

### 2.2) Use ping {#step-2-2}

If you can not install `nmap`, then you can try to `ping` the host:

```shell
ping [HOST|IP]
```

### 2.3) Use ping {#step-2-3}

If you are certain of the IP you are trying to connect to, you can try using `nmap` to access that host directly as per [step 2.1](#step-2-1). If the output differs from that of [step 2.1](#step-2-1), then you may have an issue with DNS lookup for the host not returning the correct IP address.

If you do, then this is likely due to a DNS server local to your network being misconfigured. Correcting this is outside the scope of this runbook, and will likely require you to contact the person responsible for that DNS server.


### 3) Is the port open? {#step-3}

There are two ways of determining this - from the client host and from the remote host.

#### 3.1) From client {#step-3-1}

Run this command, and check the output:

```shell
telnet [HOST|IP] [PORT]
```

If the command hangs with output like:

```
Trying 151.101.64.81...
```

then you can only say that the connection is not being explicitly rejected by the remote host. Where the connection is being stopped/dropped is impossible to say. It could be:

- by a local firewall

- by an intervening host/firewall

- by the remote host's firewall

If the request returns with a message like:

```
telnet: Unable to connect to remote host: Connection refused
```

then the request reached a remote host, and was explicitly refused.

If you connect, with a response like this:

```
Trying 151.101.0.81...
Connected to bbc.co.uk.
Escape character is '^]'.
```

Then the issue appears to be resolved. If your application is still having the same problem, then check the IP address it is trying to reach matches the IP address above.

#### 3.2) From remote host {#step-3-2}

TODO

TODO: check the interface.

#### 3.3) Conclusions {#step-3-3}

If the port appears to be open from the point of view of the remote host, but not from the point of view of the client, this suggests that there is an intervening firewall that is blocking requests from reaching the server.

### 4) Check IPTables / NetFilter {#step-4}

TODO

### 5) Check routing tables {#step-5}

TODO - explain context, advise.

This command gives a list of your machine's routes:

```shell
ip route
```

If the `ip` command is unavailable, try `route`:

```shell
route
```

### 6) Check intervening firewalls {#step-6}

TODO

- Local firewall (ie on way out)

- External firewall

- AWS/cloud provider?

## Solutions List {#solutions-list}

## Solutions Detail {#solutions-detail}

## Check Resolution {#check-resolution}

If the application no longer reports this error, then this issue is resolved.

## Further Steps {#further-steps}

None.

## Further Information {#further-information}

This error originates from the Linux kernel, eg in:

```
net/9p/error.c:114:     {"No route to host", EHOSTUNREACH},
```

It can be thrown within the kernel for a number of different reasons, which makes interpreting the error tricky.

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (https://stackoverflow.com/questions/12522396/tcp-ip-client-ehostunreach-no-route-to-host DONE)
[//]: # (https://www.maketecheasier.com/fix-no-route-to-host-error-linux/#:~:text=When%20you're%20trying%20to,that%20could%20be%20causing%20it DONE)
[//]: # (https://www.tecmint.com/fix-no-route-to-host-ssh-error-in-linux/ DONE)
[//]: # (https://superuser.com/questions/720851/connection-refused-vs-no-route-to-host TODO)
[//]: # (https://networkengineering.stackexchange.com/questions/33397/debugging-no-route-to-host-over-ethernet TODO)
[//]: # ()
