---
title: "Pod Stuck In Terminating State"
summary: "Pod Stuck In Terminating State"
---

## Overview {#overview}

A pod has been deleted, and remains in a status of Terminated for more than a few seconds.

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

1) [Gather information](#detailed-step-1)

2) [Check for finalizers](#detailed-step-2)

3) [Check the status of the node](#detailed-step-3)

4) [Force-delete the pod](#detailed-step-4)

## Detailed Steps {#detailed-steps}

### 1) Gather information {#detailed-step-1}

```
kubectl get pod -n [NAMESPACE] -p [POD_NAME] -o yaml
```

### 2) Check for finalizers {#detailed-step-2}

First we check to see whether the pod has any finalizers. If it does, their failure to complete may be the root cause.

Get the pod's configuration:

```
kubectl get pod -n [NAMESPACE] -p [POD_NAME] -o yaml > /tmp/runbooks_pod_configuration.txt
```

and look for a `finalizers` section under `metadata`. If any finalizers are present, then go to [Solution A)](#solution-a).

### 3) Check the status of the node {#detailed-step-3}

It is possible that the node your pod(s) is/are running on has failed in some way.

If you see from the `/tmp/runbooks_pod_configuration.txt` file that all pods on the same node are in a `Terminating` state on a specific node, then this may be the issue.

### 4) Delete the pod {#detailed-step-4}

The pod may not be terminating due to a process that is not responding to a signal. The exact reason will be context-specific and application dependent. Common causes include:

- A tight loop in userspace code that does not allow for interrupt signals

- A maintenance process (eg garbage collection) on the application runtime

In these cases, [Solution B)](#solution-b) may resolve the issue.

### 5) Restart kubelet {#detailed-step-5}

If nothing else works, it may be worth trying to restart the kubelet on the node the pod was trying to run on. See the output of

See [solution C)](#solution-c)

## Solutions {#solutions}

A) [Remove finalizers](#solution-a)

B) [Force-delete the pod](#solution-b)

C) [Restart kubelet](#solution-c)

### A) Remove finalizers {#solution-a}

To remove any finalizers from the pod, run:

```
kubectl patch pod [POD_NAME] -p '{"metadata":{"finalizers":null}}'
```

### B) Force-delete the pod {#solution-b}

Please note that this is more of a workaround than a solution, and should be done with care to ensure that it won't result in further problems. See also [here](https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/) for information pertaining to StatefulSets.

To force-delete the pod, run:

```
kubectl delete pod --grace-period=0 --force --namespace [NAMESPACE] [POD_NAME]
```

If this [does not work]{#check-resolution}, then return to the previous step.


### C) Restart kubelet {#solution-c}

If you can, SSH to the node and restart the kubelet process. If you do not have access or permission, this may require an administrator to get involved.

Before you do this (and if you have access), check the kubelet logs to see whether there are any issues in the kubelet logs.

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

See [further information](#further-information) for guidance on finalizers.

Common cases of finalizers not completing include:

- Volume

### 2) Determine the root cause {#further-steps-2}

This will vary depending on what the finalizer did, and will require context-specific knowledge.

Some tips:

- If you have access, check the kubelet logs. Controllers can log useful information there.

## Further Information {#further-information}

[Finalizers](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#finalizers)

[Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)

[Termination of Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods)

[Unofficial Kubernetes Pod Termination](https://unofficial-kubernetes.readthedocs.io/en/latest/concepts/abstractions/pod-termination/)

[Kubelet logs](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#looking-at-logs)

[//]: # (https://github.com/kubernetes/kubernetes/issues/51835#issuecomment-347760557 TODO)
[//]: # (https://github.com/kubernetes/kubernetes/issues/65569 DONE)
[//]: # (https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/ TODO)
[//]: # (https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods DONE)
[//]: # (https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/ DONE)
[//]: # (https://serverfault.com/questions/986177/kubernetes-update-results-in-pod-stuck-on-terminating DONE)
[//]: # (https://stackoverflow.com/questions/35453792/pods-stuck-in-terminating-status DONE)
[//]: # (https://unofficial-kubernetes.readthedocs.io/en/latest/concepts/abstractions/pod-termination/ DONE)
[//]: # (https://www.bluematador.com/docs/troubleshooting/kubernetes-pod DONE)
[//]: # (https://www.ibm.com/support/pages/kubernetes-pods-are-stuck-terminating-state DONE)
