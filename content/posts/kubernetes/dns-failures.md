---
title: "DNS Failures on Kubernetes"
summary: "When DNS fails you on K8s"
---

## Overview {#overview}

While there are networking runbooks for general DNS failures [here]({{< relref "../networking/dns-lookup-failure.md" >}}), this article deals with what to do when you have such issues ion a Kubernetes cluster.

## Check RunBook Match {#check-runbook-match}

If you see issues on your pods where you fail to connect to cluster-internal or external services using their hostnames, then this runbook may help you.

## Steps {#steps}

1) [Is this affecting all pods?](#step-1)

2) [Is this affecting all host lookups?](#step-2)

3) [Is the issue steady or intermittent?](#step-3)

4) [Has the behaviour changed?](#step-4)

5) [Is the issue happening on specific nodes?](#step-5)

6) [Check the failing pods' DNS config](#step-6)

7) [Check the health of the CoreDNS pods](#step-7)

8) [Check the CoreDNS config](#step-8)

9) [Check internal cluster lookup](#step-9)

10) [Network blocked?](#step-10)

11) [On AWS?](#step-11)

## Detailed Steps {#detailed-steps}

### 1) Is this affecting all pods? {#step-1}

First, determine (if you can) whether this issue affects all pods.

You might do this by:

- Checking the logs for your pods for network lookup errors

- Checking an external observability system to determine if all pods are showing similar errors

- `kubectl exec`ing onto the pods to try and `curl` or `nslookup` DNS lookups manually (see [step 9](#step-9))

The last option may be problematic if your pods' images do not contain these utilities.

If the issue affects all pods, then it is likely that some core component, such as the CoreDNS pods have failed. Bear this in mind as you read on.

If the issue affects only a subset of pods, then some other factor might be at play. Bear this in mind as you read on.

These factors may include:

- DNS configuration on the node

- DNS configuration on the pod/workload

### 2) Is this affecting all host lookups? {#step-2}

If the issue affects a subset of hosts that are being looked up, then this can suggest that there is a configuration issue with the values set for those hosts on the DNS servers you are using.

If the issue affects all hosts that are being looked up, then this suggests a system-wide problem on a DNS server.

### 3) Is the issue steady or intermittent? {#step-3}

If it's intermittent, either a CoreDNS pod or upstream DNS server may be giving a faulty response.

To determine which pod is the problem, see [step 7](#step-7) below.

### 4) Has the behaviour changed? {#step-4}

In this step you want to determine whether the issue is to do with your configuration (ie has been there since the workload was deployed)

If it is affecting all pods, then it is likely that the issue not to with your workload's configuration.

Determining whether your issue has arisen 'suddenly' might be done by examing current and past logs on the system.

If the behaviour changed at a specific time, then it is more likely that some core component, such as the CoreDNS pods have failed. Bear this in mind as you read on.

If the behaviour did not change at a particular time, then it is more likely that the issue is with the configuration of your workloads.

### 5) Is the issue happening on specific nodes? {#step-5}

If the issue affects all pods, then this is less likely to be the case.

If the issue is happening on specific nodes, then consider whether those nodes have a faulty DNS configuration that is being inherited by the

It's possible (for example) that a new VM image has been deployed which has changed or broken the DNS configuration, and these new images are being rolled out to new nodes on your cluster.

### 6) Check the failing pods' DNS config {#step-6}

If the issue is limited to a specific set of pods, then it may be worth checking their DNS config.

If the issue is happening on all pods, there is a chance all the pods have incorrect DNS config, so this may also be worth checking.

Pods can run with DNS config that overrides the defaults. This breaks up into two areas.

First is a DNS 'policy', eg the `dnsPolicy` here:

```
apiVersion: v1
kind: Pod
metadata:
  name: dns-config-policy-pod
spec:
  containers:
    - command:
        - sleep
        - "3600"
      image: busybox
      name: dns-config-policy-container
  hostNetwork: true
  dnsPolicy: ClusterFirstWithHostNet
```

This can have four values: `Default`, `ClusterFirst`, `ClusterFirstWithHostNet`, `None`.

If the above is set to `None`, then the DNS settings for the pod are taken from the `dnsConfig` field in the pod spec.

For more information on these settings, see [here](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy)

If you want to inspect the DNS config directly, exec onto the pod directly and run:

```
cat /etc/resolv.conf
```

If you are using the default DNS settings, then the `nameserver` entry should match the IP address of the CoreDNS service within the cluster.

You can get the cluster service IP address by running the following command and looking up the `CLUSTER-IP`:

```
kubectl get svc -n kube-system kube-dns
```

### 7) Check the health of the CoreDNS pods {#step-7}

First, check the status of the CoreDNS pods. You can do this by running:

```
kubectl -n kube-system -l k8s-app=kube-dns get pods
```

If status is `Running`, then the pods are up. If they have been running for some time, you can say the pods are stable. You can see how long they have been running by examining the output of:

```
kubectl -n kube-system -l k8s-app=kube-dns describe pods
```

Note particularly the `Started at`, and `Events` section. If the pods started very recently, then it is possible they are being restarted frequently. If there are any 'Events', then this may give a clue as to the cause.

It is also worth examining the logs with this command:

```
kubectl -n kube-system -l k8s-app=kube-dns logs
```

You may also want to consider configuring the CoreDNS pods to up the logging so that all queries are logged.

You can do this by adding 'log' to the config, eg:

```
.:53 {
    log
    errors
    health
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
```

See [step 8](#step-8) for more on the CoreDNS configmap.

### 8) Check the CoreDNS config {#step-8}

Your cluster's DNS configuration is normally set by a ConfigMap for the CoreDNS pods.

This is what it typically looks like:

```
.:53 {
    errors
    health
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
```

If anything in your file differs from this, it may be something worth investigating further.

### 9) Check pod lookup {#step-9}

If you want to check lookups from within pods, then you will need to `kubectl exec` onto the pods and run commands that can map hosts to IPs. First, find an endpoint `IP` as per [step 6](#step-6) and run:

```
nslookup kubernetes IP
```

replacing the IP with your internal IP.

You should see output similar to:

```
~ $ nslookup 10.1.0.211
nslookup: can't resolve '(null)': Name does not resolve

Name:      10.1.0.211
Address 1: 10.1.0.211 10-1-0-211.kube-dns.kube-system.svc.cluster.local
```

If `nslookup` is not available on the pod, then you can try:

- Deploying a pod with nslookup available on it, for example:

```
---
apiVersion: v1
kind: Pod
metadata:
  name: pods-simple-pod
spec:
  containers:
    - command:
        - sleep
        - "3600"
      image: busybox
      name: pods-simple-container
```

- Trying other network-related commands, eg `dig`

### 10) Network Blocked? {#step-10}

You may want to consider the possiblity that

If you are running on AWS, then consider whether your pods can't connect to one another within a cluster.

If you are using AWS, consider whether you have security groups set up that block connections between nodes (see [On AWS?](#step-11) below).

### 11) On AWS? {#step-11}

See [here](https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/) for AWS-specific advice on DNS troubleshooting, including:

- Security groups (see also [here](https://aws.amazon.com/premiumsupport/knowledge-center/eks-pod-connections/))

- `kube-proxy` pods

- VPC resolver limits


## Solutions List {#solutions-list}

A) [Restart pods](#solution-a)

## Solutions Detail {#solutions-detail}

### Restart pods {#solution-a}

In certain scenarios, restarting the affected pods may be a workaround to the problem, especially if they have cached incorrect DNS responses which are no longer returned from the DNS servers.

## Check Resolution {#check-resolution}

If there are no issues related to DNS lookups and network calls are proceeding without issue, then the issue is resolved.

## Further Information {#further-information}

[Kubernetes DNS debugging advice](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)

[EKS DNS Failure](https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/ DONE)
[//]: # (https://vexxhost.com/blog/its-always-dns/ DONE)
[//]: # (https://cilium.io/blog/2019/12/18/how-to-debug-dns-issues-in-k8s/ DONE, (cilium-specific))
[//]: # (https://medium.com/@boruah.rajen/dns-resolution-works-in-host-but-not-from-kubernetes-pod-226dcbeccc13 DONE)
[//]: # (https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/ DONE)
[//]: # (https://discover.curve.app/a/mind-of-a-problem-solver DONE)


