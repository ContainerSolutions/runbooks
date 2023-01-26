---
title: "Pod In OutOfPods State"
summary: "Pod In OutOfPods State"
---

## Overview {#overview}

An `OutOfPods` error occurs when a pod has been scheduled to a node but that node does not have enough resources to run that pod.

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```text
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       OutOfpods          0          1m
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

#### 2.1) Node didn't have enough resource

If you see lines that look like:

```text
Type     Reason     Age   From     Message
----     ------     ----  ----     -------
Warning  OutOfpods  108s  kubelet  Node didn't have enough resource: pods, requested: 1, used: 10, capacity: 10
```

This warning indicates that the node does not have enough resources to run the pod. In this case kubelet maximum pod capacity has been reached.

## Solutions List {#solutions-list}

A) [Increase the kubelet maxPods](#solution-a)

## Solutions Detail {#solutions-detail}

### A) Increase the kubelet maxPods {#solution-a}

Kubelet has a 110 pods default value for the maxPods attribute. This means that each kubelet can run up to 110 pods.

To change the default value you need administration permission on the cluster. To do so, it is required to verify if the kubelet service has a KubeletConfiguration specified. To find that out you can execute the following command on the same node as the pod has been scheduled:

```bash
systemctl show kubelet | grep -e "--config"
```

If the config file exists, the KubeletConfiguration file will be the one specified by the `--config` argument. It is possible that the property `maxPods` is not present on the file, you can append it to the yaml file with the value of your preference like this example shows:

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
[...]
syncFrequency: 0s
volumeStatsAggPeriod: 0s
maxPods: 120
```

For clusters created using kubeadm, the kubelet configuration is marshalled to disk at `/var/lib/kubelet/config.yaml` and then copied to `kube-system/kubelet-config` ConfigMap.

On the other hand, if the file is missing, you can create a KubeletConfiguration file. An example to change the `maxPods` property could be:

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
maxPods: 120
```

Save this file to a well known location, for example `/var/lib/kubelet/config.yaml`. Then update the kubelet service to add the following environment variable:

```text
KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml
```

Reload the systemctl daemon and then restart the kubelet service to get the configuration applied.

```bash
systemctl daemon-reload
systemctl restart kubelet
```

## Check Resolution {#check-resolution}

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this issue is resolved, but a new issue has been revealed.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Kubelet configuration file](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/)

[KubeletConfiguration specification](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/#kubelet-config-k8s-io-v1beta1-KubeletConfiguration)

Some cloud providers allow you to define the maximum number of pods at Kubernetes cluster creation. Usually this comes related to the CNI plugin you choose, as some of the implementations can have restrictions related with networking and IP addresses allocation. We encourage you to read specific cloud provider documentation if you are experiencing this issue or plan to migrate to a cloud service to tackle this problem:

* [Configure Azure CNI networking in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni)
* [Configfure maximum Pods per node in GKE](https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr)
* [EKS CNI custom network](https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html) and [EKS CNI increase the available IP addresses](https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html) 

## Owner {#owner}

[Carlos Vicent Domenech](https://github.com/carvido1)
