---
title: "Cannot Reach Kubernetes Service"
summary: "Unable to access Kubernetes service from outside the cluster"
---

## Overview {#overview}

Despite having set both port and targetport in the service definition, you can’t access the app from outside the cluster.

We will assume your service's YAML looks something like this:

```
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: web
  ports:
    - port: 8080
      targetport: 80
```

Where the `port` is the port on which the service is exposed, and the `targetport` is the port the service bridges to on the target container.

There are many reasons why a service cannot be reached, so this runbook does not claim to be exhaustive. However, it will be able to help you eliminate many possible failure modes.

## Check RunBook Match {#check-runbook-match}

If you are unable to make a web request via the cluster to the service, then this runbook may help you.

## Initial Steps Overview {#initial-steps-overview}

1) [Ensure that the service is running](#step-1)
<!-- can these be removed until we have a corresponding
detailed step? 
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
-->

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

## Solutions List {#solutions-list}

A) [Set Up A NodePort Service](#solution-a)

## Solutions Detail {#solutions-detail}

### Set Up A NodePort Service {#solution-a}

A NodePort Service exposes an app to the world outside the cluster via a port mapping on every node in the cluster.

If we adapt the YAML of our earlier service to make it a NodePort service, it would look like this:

```
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: web
  ports:
    - port: 8080
      targetport: 80
      nodePort: 31111
```

The nodePort is a TCP/UDP port between 30,000 and 32,767 that is mapped on every cluster node and exposes the Service to the host/node machines in the cluster.

Delete the service, then re-create it. Now when you send a request to port 31111, you should get a response.

```
kubectl get pods -o yaml | grep -i podip
    podIP: 10.244.3.5
curl -k http://10.244.3.5:31111
```

## Check Resolution {#check-resolution}

You should be able to access the service on the cluster using `wget`/`curl` or any HTTP client.

## Further Information {#further-information}

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # ()


