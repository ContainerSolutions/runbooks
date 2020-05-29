---
title: "Pod Stuck In Terminating State"
---

## Overview {#overview}

Pods have been deleted, and remain in a status of Terminated for more than a few seconds.

This can happen because:

- the pod has a finalizer associated with it that is not completing, or

- the pod is not responding to termination signals

## Check RunBook Match {#check-runbook-match}

This runbook matches if pods have been deleted and remain in a Terminated state for a long time, or a time longer than is expected.

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   1/1       Terminating        0          1h
```

## Initial Steps Overview {#initial-steps-overview}

1) [Check for finalizers](#detailed-step-1)

2) [Check the status of the node](#detailed-step-2)

3) [Force-delete the pod](#detailed-step-3)

## Detailed Steps {#detailed-steps}

### 1) Check for finalizers {#detailed-step-1}

First we check to see whether the pod has any finalizers. If it does, their failure to complete may be the root cause.

Run a describe on the pod to get its configuration:

```
kubectl describe pod -n <NAMESPACE> -p <POD_NAME> -o yaml
```

and look for a 'finalizers' section under 'metadata'. If any finalizers are present, then go to [Solution A)](#solution-a).

### 2) Check the status of the node {#detailed-step-2}

It is possible that the node your pod(s) is/are running on has failed in some way.

If you run

```
kubectl get pods -o wide --all-namspaces
```

and find that pods are in a `Terminating` state on a specific node, then this may be the issue.

### 3) Delete the pod {#detailed-step-3}

The pod may not be terminating due to a process that is not responding to a signal. The exact reason will be context-specific and application dependent. Common causes include:

- A tight loop in userspace code that does not allow for interrupt signals

- A maintenance process (eg garbage collection) on the application runtime

In these cases, [Solution B)](#solution-b) may resolve the issue.

## Solutions {#solutions}

A) [Remove finalizers](#solution-a)

B) [Force-delete the pod](#solution-b)

C) [Restart kubelet](#solution-c)

### A) Remove finalizers {#solution-a}

To remove the finalizers from the pod, run:

```
kubectl patch pod <POD_NAME> -p '{"metadata":{"finalizers":null}}'
```

### B) Force-delete the pod {#solution-b}

To force-delete the pod, run:

```
kubectl delete pod --grace-period=0 --force --namespace <NAMESPACE> <POD_NAME>
```

If this [does not work]{#check-resolution}, then return to the previous step.

### C) Restart kubelet {#solution-c}

If you can, SSH to the node and restart the kubelet process. If you do not have access or permission, this may require an administrator to get involved.

## Check Resolution {#check-resolution}

If the specific pod no longer shows up when running `kubectl get pods`

```
$ kubectl get pod -n mynamespace -p nginx-7ef9efa7cd-qasd2
NAME                     READY     STATUS             RESTARTS   AGE
```

then the issue has been resolved.

## Further Steps {#further-steps}

If the issue recurs (or not), you may want to:

1) [Check whether the finalizer's work needs to still be done]{#further-steps-1}

2) [Determine the root cause]{#further-steps-2}

### 1) Check whether the finalizer's work needs to still be done {#further-steps-1}

This will vary depending on what the finalizer did.

See [further information](#further-information) for guidance

TODO: common cases?

### 2) Determine the root cause {#further-steps-2}

This will vary depending on what the finalizer did, and will require context-specific knowledge.

TODO: common cases?

## Further Information {#further-information}

[Finalizers](https://book.kubebuilder.io/reference/using-finalizers.html)
