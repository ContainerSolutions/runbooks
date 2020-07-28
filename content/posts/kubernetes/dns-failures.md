---
title: "DNS Failures on Kubernetes"
summary: "When DNS fails you on K8s"
draft: true
---

## Overview {#overview}

While there are networking runbooks for general DNS failures [here]({{< relref "../networking/dns-lookup-failure.md" >}}), this article deals with what to do when you have such issues ion a Kubernetes cluster.

## Check RunBook Match {#check-runbook-match}

If you see issues on your pods where you cannot connect

## Initial Steps Overview {#initial-steps-overview}

1) [Is this affecting all pods?](#step-1)

2) [Has the behaviour changed?](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Is this affecting all pods? {#step-1}

First, determine (if you can) whether this issue affects all pods.

You might do this by:

- Checking the logs for your pods for network lookup errors

- Checking an external observability system to determine if all pods are showing similar errors

- `kubectl exec`ing onto the pods to try and `curl` or `nslookup` DNS lookups manually

The last option may be problematic if your pods' images do not contain these utilities.

If the issue affects all pods, then it is likely that some core component, such as the CoreDNS pods have failed. Bear this in mind as you read on.

If the issue affects only a subset of pods, then some other factor might be at play. Bear this in mind as you read on.

These factors may include:

- DNS configuration on the node

- DNS configuration on the pod/workload

### 2) Is this affecting all host lookups? {#step-2}

If the issue affects a subset of hosts, then... TODO

If the issue affects all hosts, then... TODO

### 3) Is the issue steady or intermittent? {#step-3}

TODO

If it's intermittent, either a local or upstream DNS server may be giving a faulty response.

### 4) Has the behaviour changed? {#step-4}

In this step you want to determine whether the issue is to do with your configuration (ie has been there since the workload was deployed)

If it is affecting all pods, then it is likely that the issue not to with your workload's configuration.

Determining whether your issue has arisen 'suddenly' might be done by examing current and past logs on the system.

If the behaviour changed at a specific time, then it is more likely that some core component, such as the CoreDNS pods have failed. Bear this in mind as you read on.

If the behaviour did not change at a particular time, then it is more likely that the issue is with

### 5) Is the issue happening on specific nodes? {#step-5}

If the issue affects all pods, then this is less likely to be the case.

If the issue is happening on specific nodes, then consider whether those nodes have a faulty DNS configuration that is being inherited by the

It's possible (for example) that a new VM image has been deployed which has changed or broken the DNS configuration, and these new images are being rolled out to new nodes on your cluster.


### TODO) Check the CoreDNS pods {#step-TODO}

Status and logs

See: https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/

### TODO) AWS? Blocked? {#step-TODO}

https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/
https://aws.amazon.com/premiumsupport/knowledge-center/eks-pod-connections/

### TODO) AWS? Check the kube-proxy pods {#step-TODO}

See: https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/

### TODO) Check the pods DNS config {#step-TODO}

https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/ - point 2)

### TODO) Check pod lookup {#step-TODO}

nslookup kubernetes [coredns internal IP]

### TODO) VPC resolver limits

https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/


[Link to Solution A](#solution-a)

## Solutions List {#solutions-list}

A) [Solution](#solution-a)

## Solutions Detail {#solutions-detail}

### Solution A {#solution-a}

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

1) [Further Step 1](#further-steps-1)

### Further Step 1 {#further-steps-1}

## Further Information {#further-information}

[Kubernetes DNS debugging advice](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)


## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/ DONE)
[//]: # (https://vexxhost.com/blog/its-always-dns/ TODO)
[//]: # (https://cilium.io/blog/2019/12/18/how-to-debug-dns-issues-in-k8s/ TODO)
[//]: # (https://medium.com/@boruah.rajen/dns-resolution-works-in-host-but-not-from-kubernetes-pod-226dcbeccc13 TODO)
[//]: # (https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/ TODO)
[//]: # (https://discover.curve.app/a/mind-of-a-problem-solver TODO)
[//]: # ()
[//]: # ()
[//]: # ()
