---
title: "Pod Stuck in Pending State"
summary: "Pod Stuck In Pending State"
---

## Overview {#overview}

A pod has been deployed, and remains in a Pending state for more time than is expected.

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       Pending            0          1h
```

## Initial Steps Overview {#initial-steps-overview}

1) [Gather information](#step-1)

2) [Examine pod `Events` output](#step-2)

3) [Check kubelet logs](#step-3)

4) [Is this a coredns or kube-dns pods?](#step-4)

5) [Check kubelet is running](#step-5)

6) [Debug no nodes available](#step-6)

7) [Debug `pulling image`](#step-7)

8) [Check component statuses](#step-8)

## Detailed Steps {#detailed-steps}

### 1) Gather information {#step-1}

To determine the root cause here, first gather relevant information that you may need to refer back to later:

```
kubectl describe pod -n [NAMESPACE] -p [POD_NAME] > /tmp/runbooks_describe_pod.txt
kubectl describe nodes > /tmp/runbooks_describe_nodes.txt
kubectl get componentstatuses > /tmp/runbooks_componentstatuses.txt
```

### 2) Examine pod `Events` output.

Look at the `Events` section of your `/tmp/runbooks_describe_pod.txt` file.

#### 2.1) If the last message is `pulling image`

then skip to [Debug `pulling image`](#step-8).

#### 2.2) If you see a `FailedScheduling` warning with `Insufficient cpu` or `Insuffient memory` {#step-2-2}

mentioned, you have run out of resources available to run your pod:

```
  Warning  FailedScheduling  40s (x98 over 2h)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu (1).
```

```
  Warning  FailedScheduling  40s (x98 over 2h)  default-scheduler  0/1 nodes are available: 1 Insufficient memory (1).
```

Go to [Solution B](#solution-b)

#### 2.3) If you see a `FailedScheduling [...] 0/n nodes are available` warning

mentioned, you have run out of nodes available to assign this pod to.

```
  Warning  FailedScheduling  3m (x57 over 19m)  default-scheduler  0/1 nodes are available: 1 MatchNodeSelector.
```

Skip to [debug no nodes available](#step-6).

#### 2.4) If you see a `cni config` error like this:

```
Container runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized
```

then see [Solution C](#solution-c)

#### 2.5) If you see `pod has unbound immediate PersistentVolumeClaims` warnings

like this:

```
Warning  FailedScheduling  7s (x15 over 17m)  default-scheduler  running "VolumeBinding" filter plugin for pod "podname-rh-0": pod has unbound immediate PersistentVolumeClaims
```

then consider:

* have you bound the same PersistentVolume to multiple pods (eg in a stateful set) and that these volumes can't be concurrently bound to multiple pods?

accessModes need to be `ReadWriteMany` if you want to have multiple pods access them.

See also [here](https://groups.google.com/forum/#!topic/kubernetes-users/6A1ZwSYkG8I) for more background on this.

* does the specified PersistentVolumeClaim exist?

TODO: separate 2.5 out into its own runbook and reference from here. cf: [1](https://github.com/hashicorp/consul-helm/issues/237#issuecomment-573463910)


### 3) Check the kubelet logs {#step-3}

If your pod has been assigned to a node, and you have admin access to that node, then it may be worth checking the kubelet logs for errors on that node.

Otherwise, you can run:

```
kubectl get nodes -o wide [NODE_NAME]
```

to check on the status of that node. If it does not appear ready, then run:

```
kubectl describe nodes [NODE_NAME]
```

### 4) Is this a `coredns` or `kube-dns` pod? {#step-4}

If so, this may be intentional behaviour. See [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/#coredns-or-kube-dns-is-stuck-in-the-pending-state)

### 5) Check the kubelet is running {#step-5}

If the kubelet is not running on the node the pod has been assigned to, this error may be seen.

You can check this in various ways that may be context-dependent, eg:

- `systemctl status [SERVICE_NAME]`

To determine the `SERVICE_NAME` above, you may want to run `systemctl --type service | grep kube` to determine the service name.

If the kubelet is not running, go to [restart kubelet](#solution-a)

- `ps -ef | grep kubelet`

### 6) Debug no nodes available {#step-6}

This might be caused by:


- pod demanding a particular node label

See [here](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-isolationrestriction) for more on pod restrictions and examine `/tmp/runbooks_describe_pod.txt` to see whether the pod has any nodeSelectors set, and if so, whether any available nodes match these nodes.

- pod anti-affinity

See [here](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) for more on pod affinity and anti-affinity.

You may see more useful debug information in the original warning message in `/tmp/runbooks_describe_pod.txt`:

```
Warning  FailedScheduling  <unknown>  default-scheduler  0/1 nodes are available: 1 node(s) had taint {node.kubernetes.io/disk-pressure: }, that the pod didn't tolerate.
```
- nodes being busy

If your pod could not be scheduled because nodes were busy, then [this step](#step-2-2) should have caught this.

### 7) Debug `pulling image` event {#step-7}

The first thing to consider is whether the download of the image needs more time.

If you think you have waited a sufficient amount of time, then it may be worth re-running the ```describe pod``` command from [step 1](#step-1) to see if any message has followed it.

If there is still no output, and you have admin access, you may want to log onto the node the pod has been assigned to and run the appropriate pull command (eg ```docker pull [IMAGE_NAME]```) on the image to see if the image is downloadable from the node.


### 8) Check component statuses {#step-8}

Examine the output of your `/tmp/runbooks_componentstatuses.txt` file, looking for unhealthy components.

This is most commonly a problem when a cluster has just been stood up.

## Solutions List {#solutions-list}

A) [Restart kubelet](#solution-a)

B) [Allocate resources](#solution-b)

C) [Repair your CNI](#solution-c)

## Solutions Detail {#solutions-detail}

### A) Restart kubelet {#solution-a}

How exactly to restart the kubelet will depend on its process supervisor. The most common one is `systemctl`:

```systemctl restart [SERVICE_NAME]```

If you don't know how to restart the kubelet, you may need to contact your system administrator.

### B) Allocate resources {#solution-b}

Determine whether you need to increase the resources available, or limit resources your pod requests so as not to breach the limits.
Which is appropriate depends on your particular circumstances.

### C) Repair your CNI {#solution-c}

These links may help you resolve this problem:

[Install the CNI provider](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)

More rarely, this has been suggested as a solution:

```Check if docker and kubernetes are using the same cgroup driver. I faced the same issue (CentOS 7, kubernetes v1.14.1), and setting same cgroup driver (systemd) fixed it.``` [Source](https://stackoverflow.com/questions/52609257/coredns-in-pending-state-in-kubernetes-cluster)

## Check Resolution {#check-resolution}

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this particular issue is resolved, but a new issue has been revealed.

If it has not been resolved by this runbook, then please comment below.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

See [here](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) for background information on pod placement.

[Kubelet logs](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#looking-at-logs)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)


[//]: # (REFERENCED DOCS)
[//]: # (https://kubernetes.io/docs/tasks/debug-application-cluster/debug-pod-replication-controller/#my-pod-stays-pending DONE)
[//]: # (https://stackoverflow.com/questions/32643379/pods-hang-in-pending-state-indefinitely DONE - MTU issue? (too rare))
[//]: # (https://stackoverflow.com/questions/36377784/pod-in-kubernetes-always-in-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/46424423/pod-hangs-in-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/48303618/pods-stuck-in-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/51456849/kubernetes-pods-status-is-always-pending DONE)
[//]: # (https://stackoverflow.com/questions/52609257/coredns-in-pending-state-in-kubernetes-cluster DONE)
[//]: # (https://stackoverflow.com/questions/54923806/why-do-i-get-unbound-immediate-persistentvolumeclaims-on-minikube DONE)
[//]: # (https://stackoverflow.com/questions/54943271/kubernetes-pods-in-pending-state-for-indfinite-time DONE)
[//]: # (https://stackoverflow.com/questions/55208598/kubernetes-pods-is-in-status-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/56598189/pod-stuck-in-pending-state-after-kubectl-apply DONE)
[//]: # (https://stackoverflow.com/questions/53868431/how-to-restart-a-kubernetes-pod-stuck-in-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/59015560/pod-is-in-pending-state-on-single-node-kubernetes-cluster DONE)
[//]: # (https://stackoverflow.com/questions/55310076/pods-are-in-pending-state DONE)
[//]: # ()
