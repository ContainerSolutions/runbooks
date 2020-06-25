---
title: "Determine Operating System Information"
summary: "How to determine your operating system details"
---

## Overview {#overview}

This runbook tells you how to determine your operating system and associated details.

## Check RunBook Match {#check-runbook-match}

Use this runbook if you want to know details of the operating system you are running.

## Initial Steps Overview {#initial-steps-overview}

1) [Get a terminal](#step-1)

2) [Run `uname`](#step-2)

3) [Get Linux OS Details](#step-3)

4) [Get Mac OS Details](#step-4)

5) [Get Windows OS Details](#step-5)

## Detailed Steps {#detailed-steps}

### 1) Get a terminal {#step-1}

If you are not sure how to this, here are some methods you can try:

- Use an application finder and search for 'terminal'

### 2) Run `uname` {#step-2}

In your terminal, run `uname`.

- If you see the output `Linux`, note down that you are on a Linux operating system. Go to [Step 3](#step-3)

- If you see the output `Darwin`, note that you are on a Mac/iOS operating system. Go to [Step 4](#step-4)

- If you see [TODO] then you are on a Windows machine. Go to [Step 5](#step-5)

*NOTE* If you run this on a container, the output will refer to the host machine's operating system, not the container's (technically, the container doesn't have an operating system, it has a distribution, eg Debain).

### 3) Get Linux OS Details {#step-3}

### 3.1) Run `uname -a` {#step-3-1}

Running this command will get you information about the running kernel:

```shell
uname -a
```

The example output:

```
Linux dali 5.4.0-37-generic #41-Ubuntu SMP Wed Jun 3 18:57:02 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
```

tells you (in order) the:

- OS / Kernel name (`Linux` above)

- Nodename / short hostname (`dali` above)

- Kernel release (`5.4.0-37-generic` above)

- Kernel version (`#41-Ubuntu SMP Wed Jun 3 18:57:02 UTC 2020` above)

- Machine hardware name (`x86_64` above)

- Processor type (`x86_64` above)

- Hardware platform (`x86_64` above)

- Operating system (`GNU/Linux` above)

*NOTE* If you run this on a container, the output will refer to the host machine's operating system, not the container's (technically, the container doesn't have an operating system, it has a distribution, eg Debain).

### 3.2) Get Linux OS Details {#step-3-2}

If you have the `lsb_release` command available on your machine, you can run:

```shell
lsb_release -a
```

to get the following details:

```
Distributor ID: Ubuntu
Description:    Ubuntu 20.04 LTS
Release:        20.04
Codename:       focal
```

If you don't have this command, then you can try installing it in your package manager (search for `lsb-core`, eg `centos-lsb-core`, or `lsb-release`). Confusingly, the command has an underscore, but the package name usually has dashes.

### 3.3) Get Linux OS Distribution {#step-3-3}

There are some `/etc` files that may give you more information:

```shell
cat /etc/issue
cat /etc/issue.net
cat /etc/os-release
```

### 3.4) Per-Distribution Information {#step-3-4}

Depending on your distribution, more information may be gleaned.

#### 3.4.1) RedHat / CentOS {#step-3-4-1}

```shell
cat /etc/centos-release
cat /etc/redhat-release
cat /etc/system-release
cat /etc/system-release-cpe
```

### 4) Get Mac OS Details {#step-4}

TODO

### 5) Get Windows OS Details {#step-5}

TODO

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[//]: # (REFERENCED DOCS)
[//]: # (eg https://somestackoverflowpage)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)
