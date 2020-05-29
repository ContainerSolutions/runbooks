---
title: "Pod Stuck in Pending State"
summary: "Pod Stuck In Pending State"
---

## Overview {#overview}

A pod has been deployed, and remains in a Pending state for more time than is expected.

This most commonly happens because:

- the cluster doesn't have enough resources to start the

- a container image is still downloading, or is hanging on download

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       Pending            0          1h
```

## Initial Steps Overview {#initial-steps-overview}

1) [Describe pod](#step-1)

2) [Check kubelet logs](#step-2)

3) [Get events on the cluster](#step-3)

4) [Is this a coredns or kube-dns pods?](#step-4)

5) [Check kubelet is running](#step-5)

## Detailed Steps {#detailed-steps}

### 1) Describe Pod {#step-1}

Decsribe the pod in question, with a wide output:

```
kubectl describe pod -n <NAMESPACE> -p <POD_NAME> -o wide
```

1.1) Has the pod been assigned to a node?

If the NODE column of your pod does not show a node assigned to the pod, then ... TODO

1.2) examine the 'Events' output.

- If the last message is 'pulling image'... TODO

- If you see a 'FailedScheduling' error with 'Insufficient cpu' mentioned, you have run out of resources:

```
  Warning  FailedScheduling  40s (x98 over 2h)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu.
```

TODO: what next? other error messages?

- If you see 'pod has unbound immediate PersistentVolumeClaims' ... TODO

- hostPort exhaustion? TODO

### 2) Check the kubelet logs {#step-2}

If you have access... TODO

### 3) Get events on the cluster {#step-3}

Run:

```
kubectl get events --all-namespaces
```

and look for any possibly relevant errors.

### 4) Is this a coredns or kube-dns pod? {#step-4}

If so, this may be intentional behaviour. See [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/#coredns-or-kube-dns-is-stuck-in-the-pending-state)

### 5) Check the kubelet is running {#step-5}

If the kubelet is not running on the node the pod has been assigned to, this error may be seen.

TODO - how to check

If the kubelet is not running, go to [restart kubelet]{#solution-a}

## Solutions {#solutions}

A) [Restart kubelet](#solution-a)

### Restart kubelet {#solution-a}

TODO - systemctl (usually)

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

None

## Further Information {#further-information}

None


[//]: # (REFERENCED DOCS)
[//]: # (https://stackoverflow.com/questions/55208598/kubernetes-pods-is-in-status-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/36377784/pod-in-kubernetes-always-in-pending-state DONE)
[//]: # (https://stackoverflow.com/questions/51456849/kubernetes-pods-status-is-always-pending TODO)
[//]: # (https://stackoverflow.com/questions/53868431/how-to-restart-a-kubernetes-pod-stuck-in-pending-state TODO)
[//]: # (https://stackoverflow.com/questions/59015560/pod-is-in-pending-state-on-single-node-kubernetes-cluster TODO)
[//]: # (https://stackoverflow.com/questions/48303618/pods-stuck-in-pending-state TODO)
[//]: # (https://stackoverflow.com/questions/56598189/pod-stuck-in-pending-state-after-kubectl-apply TODO)
[//]: # (https://stackoverflow.com/questions/55310076/pods-are-in-pending-state TODO)
[//]: # (https://stackoverflow.com/questions/54943271/kubernetes-pods-in-pending-state-for-indfinite-time TODO)
[//]: # (https://stackoverflow.com/questions/46424423/pod-hangs-in-pending-state TODO)
[//]: # (https://stackoverflow.com/questions/52609257/coredns-in-pending-state-in-kubernetes-cluster TODO)
[//]: # (https://stackoverflow.com/questions/32643379/pods-hang-in-pending-state-indefinitely TODO - MTU issue? (rare))
[//]: # ()
