---
title: "CrashLoopBackOff"
---

# Overview

A 'CrashLoopBackOff' error occurs when a Pod startup fails repeatedly in Kubernetes.

# Check RunBook Match

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       CrashLoopBackOff   2          1m
```

# Initial Steps Overview

1) Run describe

2) Examine 'Events' section in output

3) Check the exit code

4) Check readiness/liveness probes

# Detailed Steps

## 1) Run describe

```
kubectl describe -n <NAMESPACE_NAME> pod <POD_NAME>`
```

## 2) Examine 'Events' section in output

### 2.1) Check logs of container

If application is failing, run

```
kubectl logs -n <NAMESPACE_NAME> -p <POD_NAME>`
```

If the container is running as part of a group, you may need to add the container name to the logs

```
kubectl logs -c <CONTAINER_NAME> -p <POD_NAME>`
```

## 3) Examine the 'Last State' section

```
kubectl describe -n <NAMESPACE_NAME> -p <POD_NAME> | grep -A5 Last.State:
```

If the 'Exit Code' is `127`, then the command specified to run (in the container or in the pod specification) could not be found. See Solution C) below

If the container immediately exits (TODO: how is this identitified?), then you may need to add a command. See Solution B) below.

## 4) Check readiness / liveness probes

If these are too short for the application initialization time, then Kubernetes may be killing the application too early.

Whether the time taken to start is longer because there is a problem, or whether the time take to start is genuinely longer than the probe times is a judgement for the reader/application owner.

If the probe times are too short, see Solution D) below.

# Solutions

A) Fix the application

B) Add a startup command

C) Correct the container or spec to run a command that exists in the container

D) Adjust the time for the liveness/readiness probes

## A) Fix the application

This is outside the scope of this runbook.

## B) Add a startup command

In order for a pod to start, it needs a startup command. Consider adding one to the container image, or adding a command to the

## C) Correct the container or spec to run a command that exists in the container

TODO

## D) Adjust the time for the liveness/readiness probes

TODO

# Check resolution

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this issue is resolved, but a new issue has been revealed.

# Further steps

None

# Further information

None
