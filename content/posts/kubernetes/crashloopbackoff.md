---
title: "CrashLoopBackOff"
summary: "Pod in CrashLoopBackOff State"
---

## Overview {#overview}

A 'CrashLoopBackOff' error occurs when a pod startup fails repeatedly in Kubernetes.

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       CrashLoopBackOff   2          1m
```

If you see something like:

```
NAME                     READY     STATUS                  RESTARTS   AGE
pod1-7ef9efa7cd-qasd2    0/2       Init:CrashLoopBackOff   2          1m
```

then continue with this runbook, bearing in mind that the problem is likely specific to the init container.

## Initial Steps Overview {#initial-steps-overview}

1) [Run describe on pod](#step-1)

2) [Examine 'Events' section in describe output](#step-2)

3) [Check the exit code](#step-3)

4) [Check readiness/liveness probes](#step-4)

## Detailed Steps {#detailed-steps}

### 1) Run describe on pod {#step-1}

```
kubectl describe -n <NAMESPACE_NAME> pod <POD_NAME>`
```

### 2) Examine 'Events' section in output {#step-2}

If application is failing, run

```
kubectl logs -n <NAMESPACE_NAME> -p <POD_NAME>`
```

If the container is running as part of a group of containers, you may need to add the container name to the logs to specify which container you are interested in:

```
kubectl logs -c <CONTAINER_NAME> -p <POD_NAME>`
```

### 3) Examine the 'Last State' section {#step-3}

```
kubectl describe -n <NAMESPACE_NAME> -p <POD_NAME> | grep -A5 Last.State:
```

If the 'Exit Code' is `127`, then the command specified to run (in the container or in the pod specification) could not be found. See Solution C) below

If the 'Exit Code' is `126`, then the command specified to run (in the container or in the pod specification) could be found, but not run. See Solution C) below

If the container immediately exits (TODO: how is this identitified?), then you may need to add a command. See Solution B) below.

### 4) Check readiness / liveness probes {#step-4}

If these are too short for the application initialization time, then Kubernetes may be killing the application too early.

Whether the time taken to start is longer because there is a problem, or whether the time take to start is genuinely longer than the probe times is a judgement for the reader/application owner.

If the probe times are too short, see Solution D) below.

## Solutions {#solutions}

A) [Fix the application](#solution-a)

B) [Add a startup command](#solution-b)

C) [Correct the container or spec to run a command that exists in the container, and is executable](#solution-c)

D) [Adjust the time for the liveness/readiness probes](#solution-d)

### A) Fix the application {#solution-a}

This is outside the scope of this runbook.

### B) Add a startup command {#solution-b}

In order for a pod to start, it needs a startup command. Consider adding one to the container image, or adding a command to the

### C) Correct the container or spec to run a command that exists in the container {#solution-c}

If the command was not specified (both in the image and the pod specification), then add a command in either place.

If the command was not executable, make it executable. This may require a change to the container build, or specifying a correct executable.

### D) Adjust the time for the liveness/readiness probes {#solution-d}

TODO

## Check Resolution {#check-resolution}

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this issue is resolved, but a new issue has been revealed.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
