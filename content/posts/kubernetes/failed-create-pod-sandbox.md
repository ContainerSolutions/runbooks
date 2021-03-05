---
title: "Failed Create Pod Sandbox"
summary: "Pods not running, with FailedCreatePodSandBox error"
---

## Overview {#overview}

Pods remain in Pending phase 

This was on a Managed GKE cluster

## Check RunBook Match {#check-runbook-match}

When you see these errors:

```
Type     Reason                  Age                     From     Message
  ----     ------                  ----                    ----     -------
  Warning  FailedSync              47m (x27 over 3h)       kubelet  error determining status: rpc error: code = DeadlineExceeded desc = context deadline exceeded
  Warning  FailedCreatePodSandBox  7m56s (x38 over 3h23m)  kubelet  Failed to create pod sandbox: rpc error: code = Unknown desc = failed to start sandbox container for pod "xxx": operation timeout: context deadline exceeded
```

Also noticed running `kubectl top nodes`

```
NAME                                                 CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
node-1-xxx   158m         16%    2311Mi          87%
node-2-xxx   111m         11%    1456Mi          55%
node-3-xxx   391m         41%    1662Mi          63%
node-4-xxx   169m         17%    2210Mi          83%
node-5-xxx   <unknown>   <unknown>   <unknown>   <unknown>
```

Also noticed node events showed the node was repeatedly restarting, ran `kubectl describe node-5-xxx`

```
Events:
  Type    Reason        Age                     From     Message
  ----    ------        ----                    ----     -------
  Normal  NodeNotReady  3m15s (x2344 over 10d)  kubelet  Node node-5-xxx status is now: NodeNotReady
  Normal  NodeReady     2m15s (x2345 over 49d)  kubelet  Node node-5-xxx status is now: NodeReady
```

## Initial Steps Overview {#initial-steps-overview}

1) [Investigate the failing pod](#step-1)

2) [Identify the node the pod is meant to be scheduled on](#step-2)

3) [Investigate the node](#step-3)

## Detailed Steps {#detailed-steps}

### 1) Investigate the failing pod {#step-1}

Check the logs of the pod:

    $ kubectl logs pod-xxx

Check the events of the pod:

    $ kubectl describe pod pod-xxx

### 2) Investigate the node the pod is meant to be scheduled on {#step-2}

Describe pod and see what **node** the pod is meant to be running on:

    $ kubectl describe pod-xxx

Ouput will start with something like this, look for the "Node: " part:

```
Name:         pod-xxx
Namespace:    office-updates
Priority:     0
Node:         node-xxx
```

### 3) Investigate the node {#step-3}

Check the resources of the nodes:

    $ kubectl top nodes

Check the events of the node you identified the pod was meant to be scheduled on:

    $ kubectl describe node node-xxx

## Solutions List {#solutions-list}

A) [Remove problematic node](#solution-a)

## Solutions Detail {#solutions-detail}

The solution was to remove the problematic node, see more details below.

### A) Remove problematic node {#solution-a}

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

1) [Create Extra Node](#further-steps-1)

2) [Drain Problematic Node](#further-steps-2)

3) [Delete Problematic Node](#further-steps-3)

### 1) Create Extra Node {#further-steps-1}

You may need to create a new node before draining this node. Just check with `kubectl top nodes` to see if the nodes have extra capacity to schedule your drained pods.

If you see you need an extra node before you drain the node, make sure to do so.

In our situation we were using Managed GKE cluster, so we added a new node via the console.

### 2) Drain Problematic Node {#further-steps-2}

Once you are sure there is enough capacity amongst your remaining nodes to schedule the pods that are on the problematic node, then you can go ahead and drain the node.

    $ kubectl drain node-xxx

### 3) Delete Problematic Node {#further-steps-3}

Check once all scheduled pods have been drained off of the node. 

    $ kubectl get nodes

Once done you can delete the node:

    $ kubectl delete node node-xxx

## Further Information {#further-information}

## Owner {#owner}

[Cari Liebenberg](https://github.com/CariZa)

[//]: # (REFERENCED DOCS)
[//]: # (https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)

