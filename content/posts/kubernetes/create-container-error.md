---
title: "Simple Runbook Template"
summary: "Summary here"
---

## Overview {#overview}

This issue happens when... TODO

## Check RunBook Match {#check-runbook-match}

When you ... you expect to see ...

## Initial Steps Overview {#initial-steps-overview}

1) [Gather information](#step-1)

2) [Examine `Events` section in describe output](#step-2)

## Detailed Steps {#detailed-steps}


### 1) Gather information {#step-1}

To determine the root cause here, first gather relevant information that you may need to refer back to later:

```
kubectl describe pod -n [NAMESPACE] -p [POD_NAME] > /tmp/runbooks_describe_pod.txt
```

### 2) Examine pod `Events` output {#step-2}

Look at the 'Events' section of your `/tmp/runbooks_describe_pod.txt` file.

#### 2.1) If you see `no command specified`

TODO

```
Warning  Failed     116s                kubelet, dali      Error: failed to generate container "be3707fcf873ecc052ff73d3ffe7ed3a51eec0756b84839f908f7c9ab730ae74" spec: no command specified
```

## Solutions {#solutions}

TODO

A) [Solution](#solution-a)

### Solution A {#solution-a}

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

1) [Further Step 1](#further-steps-1)

### Further Step 1 {#further-steps-1}

## Further Information {#further-information}

[//]: # (REFERENCED DOCS)
[//]: # (eg )
