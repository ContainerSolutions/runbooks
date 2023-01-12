---
title: "Pod In InvalidImageName State"
summary: "Pod In InvalidImageName State"
---

## Overview {#overview}

An `InvalidImageName` error occurs when kubelet attempts to pull a container image from the container registry and the image name reference is not correct.

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```text
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       InvalidImageName   0          1m
```

## Initial Steps Overview {#initial-steps-overview}

1) [Gather information](#step-1)

2) [Examine `Events` section in describe output](#step-2)

3) [Check the error message](#step-3)

## Detailed Steps {#detailed-steps}

### 1) Gather information {#step-1}

Run this commands to gather relevant information in one step:

```shell
kubectl describe -n [NAMESPACE_NAME] pod [POD_NAME]` > /tmp/runbooks_describe_pod.txt
```

### 2) Examine `Events` section in describe output {#step-2}

#### 2.1) Invalid reference format

If you see lines that look like:

```text
Type     Reason         Age                   From               Message
----     ------         ----                  ----               -------
Normal   Scheduled      2m45s                 default-scheduler  Successfully assigned default/nginx-7ef9efa7cd-qasd2 to kind-control-plane
Warning  Failed         38s (x12 over 2m45s)  kubelet            Error: InvalidImageName
Warning  InspectFailed  24s (x13 over 2m45s)  kubelet            Failed to apply default image tag "https://docker.io/nginx:latest": couldn't parse image reference "https://docker.io/nginx:latest": invalid reference format
```

Then this indicates that the container image reference you have specified can't be parsed, therefore kubelet from the node the pod has been scheduled to can't pull the container image.

## Solutions List {#solutions-list}

A) [Review the image reference](#solution-a)

## Solutions Detail {#solutions-detail}

### A) Add credentials {#solution-a}

Review the container image reference in your manifest. The container image has two parts, the image name and the image tag. You can include a container registry hostname and the port as well. Protocols like `http://`, `ssh://`, `docker://` are not allowed and can lead to this issue. The container image tag consists of lowercase and uppercase letters, digits, underscores, periods and dashes, any other symbol can cause this issue to appear.

## Check Resolution {#check-resolution}

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this issue is resolved, but a new issue has been revealed.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Image names documentation](https://kubernetes.io/docs/concepts/containers/images/#image-names)

## Owner {#owner}

[Carlos Vicent Domenech](https://github.com/carvido1)
