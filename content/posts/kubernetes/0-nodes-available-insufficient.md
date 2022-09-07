---
title: "0/1 nodes available: insufficient cpu, insufficient memory"
summary: "No nodes available errors"
draft: false
---

## Overview {#overview}

Example errors:

```
0/1 nodes available: insufficient memory
0/1 nodes available: insufficient cpu
```

More generally:

```
0/[n] nodes available: insufficient [resource]
```

This issue happens when Kubernetes does not have enough resources to fulfil your workload request.

## Initial Steps Overview {#initial-steps-overview}

1) [Determine requested resources](#step-1)

2) [Have you requested too many resources?](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Determine requested resources {#step-1}

To determine your requested resources for your workload, you must first extract its YAML.

What type of resource to extract the YAML for may depend, but most commonly you can just get the YAML for the pod that reports the problem.

From that YAML, determine whether there are any resource requests made in the `containers` section, under `resources`.

A simplified YAML that makes a large request for memory resources (1000G) might look like this, for example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: too-much-mem
spec:
  containers:
    - command:
        - sleep
        - "3600"
      image: busybox
      name: broken-pods-too-much-mem-container
      resources:
        requests:
          memory: "1000Gi"
```

If no resource requests are in the YAML, then a default request may be made. What this request is will depend on other configuration in the cluster. See [here](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/) for more information.

See [here](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more information.

If no request is made and you are out of resources, then it is likely that you have no available nodes. At this point you need to consider [solution A](#solution-a).

### 2) Have you requested too many resources? {#step-2}

If you _have_ made a resource request, then there are two possibilities:

- Your resource request cannot fit into any node on the cluster

- Your resource request can fit on a node in the cluster, but those nodes already have workloads running on them which block yours being provisioned

[Step 1](#step-1) should have shown you whether you are specifically requesting resources. Once you know what those resources are, you can compare them to the resources available on each node.

If you are able, run:

```sh
kubectl describe nodes
```

which, under 'Capacity:', 'Allocatable:', and 'Allocated resources:' will tell you the resources available in each node, eg:

```
$ kubectl describe nodes
[...]
Capacity:
  cpu:                4
  ephemeral-storage:  61255492Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             2038904Ki
  pods:               110
Allocatable:
  cpu:                4
  ephemeral-storage:  56453061334
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             1936504Ki
  pods:               110
[...]
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                750m (18%)  0 (0%)
  memory             140Mi (7%)  340Mi (17%)
  ephemeral-storage  0 (0%)      0 (0%)
  hugepages-1Gi      0 (0%)      0 (0%)
  hugepages-2Mi      0 (0%)      0 (0%)
```

You should be able to compare these to the resources you requested to determine why your request was not met, and choose where to [autoscale](#solution-a) or [provision a larger node](#solution-b) accordingly.

[Link to Solution A](#solution-a)

## Solutions List {#solutions-list}

A) [Set up autoscaling](#solution-a)

B) [Provision appropriately-sized nodes](#solution-b)

## Solutions Detail {#solutions-detail}

### A) Set up autoscaling {#solution-a}

The details of this will vary depending on your platform, but in general the principle is that you have legitimately used up all your resources, and you ened more nodes to take the load.

Note this solution will not work if:

- Your nodes are unavailable for other reasons (such as: you have a 'runaway' workload that is consuming all the resources it finds), as you will see this error again once the new resources are consumed.

- Your workload cannot fit on any node in the cluster

Some potentially useful links to achieving this:

- [K8s autoscaling](https://kubernetes.io/blog/2016/07/autoscaling-in-kubernetes/)
- [EKS](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html)
- [GKE](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-autoscaler)
- [AKS](https://azure.microsoft.com/en-gb/updates/generally-available-aks-cluster-autoscaler/)

### B) Provision appropriately-sized nodes {#solution-a}

The details of this will vary according to your platform. You will need to add a node (or set of nodes) that exceeds in size the amount your workload is requesting.

Also note: your workload scheduler may 'actively' or 'intelligently' move workloads to make them all 'fit' onto the given nodes. In these cases, you may need to significantly over-provision node sizes to reliably accommodate your workload.

## Check Resolution {#check-resolution}

If the error is no longer seen in the workload description in Kubernetes, then this particular issue has been resolved.

## Further Information {#further-information}

When you make a request for Kubernetes to run your workload, it tries to find all the nodes that can fulfil the requirements.

[Kubernetes resource management docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

## Owner {#owner}

email

[//]: # (REFERENCED DOCS)
[//]: # (eg https://somestackoverflowpage)
[//]: # (https://github.com/kubernetes/kubernetes/issues/33777 - TODO)
