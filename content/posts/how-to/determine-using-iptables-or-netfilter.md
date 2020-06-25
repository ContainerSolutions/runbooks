---
title: "Am I Using IPTables or NetFilter"
summary: "Determine whether IPTables or NetFilter is in use on the system"
---

## Overview {#overview}

This how-to tells you whether IPTables is in use on your system.

It assumes you are on Linux. If you are not sure about that, see [here]({{< relref "determine-operating-system.md" >}})

## Initial Steps Overview {#initial-steps-overview}

1) [Run `lsmod`](#step-1)

2) [Run `iptables-save`](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Run `lsmod` {#step-1}

If this command generates any output, then IPTables is in effect on the system:

```
lsmod | grep -wi iptables
```

If this command generates any output, then NetFilter is in effect on the system:

```shell
lsmod | grep -i netfilter
```

## Further Information {#further-information}

Note that the `iptables` command is back-compatible with NetFilter, which has replaced IPTables in most Linux kernels.

Thus, while technically NetFilter is being used rather than IPTables, you can still work as though IPTables is installed.

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (eg https://somestackoverflowpage)
[//]: # ()
