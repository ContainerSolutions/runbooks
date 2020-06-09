---
title: "CreateContainerError"
summary: "Pod failing with CreateContainerError"
---

## Overview {#overview}

This issue happens when Kubernetes tries to create a container (a precursor to the 'run' phase of the container) but fails.

It generally implies some kind of issue with the container runtime, but can also indicate a problem starting up the container, such as the command not existing.

This symptom can also lead to CrashLoopBackOff errors, so it may be worth looking at [that runbook]({{< relref "crashloopbackoff.md" >}}) if this one does not resolve your issue.

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS                RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       CreateContainerError  2          1m
```

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

Look at the `Events` section of your `/tmp/runbooks_describe_pod.txt` file.

#### 2.1) If you see `no command specified`

Like this:

```
Warning  Failed     116s                kubelet, dali      Error: failed to generate container "be3707fcf873ecc052ff73d3ffe7ed3a51eec0756b84839f908f7c9ab730ae74" spec: no command specified
```

then the error is caused by both the image and pod specification not specifying a command to run. See the [CrashLoopBackOff runbook]({{< relref "crashloopbackoff.md#solution-b" >}}) solution B.

#### 2.2) If you see `starting container process caused`

Then the message following this explains what happened on the node when the container process was run

For example, if the error looks like this:

```
Warning  Failed                 8s (x3 over 22s)  kubelet, nginx-7ef9efa7cd-qasd2  Error: container create failed: container_linux.go:296: starting container process caused "exec: \"mycommand\": executable file not found in $PATH"
```

then starting command might not be available on the image. Correct the container start command - or the image's contents - accordingly. See the [CrashLoopBackOff runbook]({{< relref "crashloopbackoff.md#solution-c" >}}) solution C.
[//]: # (https://bugzilla.redhat.com/show_bug.cgi?id=1537478 DONE)

#### 2.3) If you see `container name [...] already in use by container`

For example:

```
The container name "/k8s_kube-apiserver_kube-apiserver-master_kube-system_ce0f74ad5fcbf28c940c111df265f4c8_24" is already in use by container 14935b714aee924aa42295fa5d252c760264d24ee63ea74e67092ccc3fb2b530. You have to remove (or rename) that container to be able to reuse that name.
```

Then it is likely there is a problem with the container runtime on that host not cleaning up old containers. If you have admin access, check the kubelet logs on the node the container was assigned to.

#### 2.4) If you see `is waiting to start`

In the error message, like this:

```
container "nginx" in pod "nginx-1234567890-12345" is waiting to start: CreateContainerConfigError
```

then the issue may be to do with

- Volume/secrets mounting.

If there is an [Init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/), then look at the logs for that, as it may be responsible for provisioning the volume. (TODO: more detail on this)

Check any secrets and/or configmaps in the pod are available to your pods in your namespace.


[//]: # (## Solutions {#solutions})
[//]: # ()
[//]: # (### Solution A {#solution-a})

## Check Resolution {#check-resolution}

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this particular issue is resolved, but a new issue has been revealed, and the runbook needs to be re-followed.

If it has not been resolved by this runbook, then please comment below.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

[Kubelet logs](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#looking-at-logs)

## Owner {#owner}

ian.miell@container-solutions.com

[//]: # (REFERENCED DOCS)
[//]: # (https://discuss.kubernetes.io/t/failed-job-pod-container-troubleshooting/6144 DONE)
[//]: # (https://bugzilla.redhat.com/show_bug.cgi?id=1537478 DONE)
[//]: # (https://github.com/cri-o/cri-o/issues/1927 DONE)
[//]: # (https://github.com/cri-o/cri-o/issues/815 DONE)
[//]: # (https://stackoverflow.com/questions/57143214/about-createcontainererror DONE)
[//]: # (https://stackoverflow.com/questions/57476752/kube-apiserver-pod-sticks-in-the-createcontainererror-status DONE)
[//]: # (https://stackoverflow.com/questions/58390812/how-to-fix-kubernetes-create-container-error DONE)
[//]: # (https://stackoverflow.com/questions/61350893/kubernetes-gcp-error-response-from-daemon-no-command-specified-createcontainer DONE)
[//]: # (https://stackoverflow.com/questions/50424754/pod-status-as-createcontainerconfigerror-in-minikube-cluster DONE)
[//]: # (https://stackoverflow.com/questions/57821723/list-of-all-reasons-for-container-states-in-kubernetes DONE)
[//]: # ()
[//]: # ()
[//]: # ()
[//]: # ()
