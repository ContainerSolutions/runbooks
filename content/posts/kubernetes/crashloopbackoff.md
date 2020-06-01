---
title: "Pod In CrashLoopBackOff State"
summary: "Pod In CrashLoopBackOff State"
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

1) [Gather information](#step-1)

2) [Examine 'Events' section in describe output](#step-2)

3) [Check the exit code](#step-3)

4) [Check readiness/liveness probes](#step-4)

## Detailed Steps {#detailed-steps}

### 1) Run describe on pod {#step-1}

Run these commands to gather relevant information in one step:

```
kubectl describe -n [NAMESPACE_NAME] pod [POD_NAME] > /tmp/runbooks_describe_pod.txt
kubectl logs --all-containers -n [NAMESPACE_NAME] > /tmp/runbooks_pod_logs.txt
```

### 2) Examine 'Events' section in output {#step-2}

Look at the 'Events' section of your `/tmp/runbooks_describe_pod.txt` file.

#### 2.1) `Back-off restarting failed container`

If you see a warning like the following in your `/tmp/runbooks_describe_pod.txt` output:

```
Warning  BackOff    8s (x2 over 9s)    kubelet, dali      Back-off restarting failed container
```

then the pod has repeatedly failed to start up successfully.

Make a note of any containers that have a `State` of `Waiting` in the description and a description of `CrashLoopBackOff`. These are the containers you will need to fix.

### 3) Check the exit code {#step-3}

TODO

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

If there is a different status, then it may be that this particular issue is resolved, but a new issue has been revealed, and the runbook needs to be re-followed.

If it has not been resolved by this runbook, then please comment below.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

[//]: # (REFERENCED DOCS)
[//]: # (https://aws.amazon.com/premiumsupport/knowledge-center/eks-pod-status-troubleshooting/ TODO)
[//]: # (https://dev.to/wingkwong/how-to-debug-crashloopbackoff-when-starting-a-pod-in-kubernetes-4i07 TODO)
[//]: # (https://github.com/kubernetes/kubernetes/issues/76619 TODO)
[//]: # (https://github.com/rancher/k3s/issues/1019 TODO)
[//]: # (https://kb.vmware.com/s/article/76870 TODO)
[//]: # (https://kubernetes.io/docs/tasks/debug-application-cluster/determine-reason-pod-failure/ TODO)
[//]: # (https://managedkube.com/kubernetes/pod/failure/crashloopbackoff/k8sbot/troubleshooting/2019/02/12/pod-failure-crashloopbackoff.html TODO)
[//]: # (https://medium.com/@deepeshtripathi/kubernetes-controller-pod-crashloopbackoff-resolved-16aaa1c27cfci TODO)
[//]: # (https://stackoverflow.com/questions/41604499/my-kubernetes-pods-keep-crashing-with-crashloopbackoff-but-i-cant-find-any-lo DONE)
[//]: # (https://sysdig.com/blog/debug-kubernetes-crashloopbackoff/ DONE)
[//]: # (https://www.krenger.ch/blog/crashloopbackoff-and-how-to-fix-it/ TODO)
[//]: # ()
[//]: # ()
[//]: # ()
[//]: # ()
