---
title: "Pod In ImagePullBackOff State"
summary: "Pod In ImagePullBackOff State"
---

## Overview {#overview}

An `ImagePullBackOff` error occurs when a Pod startup fails due to an inability to pull the image.

## Check RunBook Match {#check-runbook-match}

When running a `kubectl get pods` command, you will see a line like this in the output for your pod:

```
NAME                     READY     STATUS             RESTARTS   AGE
nginx-7ef9efa7cd-qasd2   0/1       ImagePullBackOff   0          1m
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

#### 2.1) Repository does not exist

If you see lines that look like:

```
Warning  Failed     27s (x4 over 62s)   kubelet, gke-cs-79ec0e47-kfkc  Error: ImagePullBackOff
Warning  Failed     12s (x4 over 92s)  kubelet, gke-cs-79ec0e47-kfkc  Failed to pull image "nginx": rpc error: code = Unknown desc = Error response from daemon: repository nginx not found: does not exist or no pull access
Warning  Failed     12s (x4 over 93s)  kubelet, gke-cs-79ec0e47-kfkc  Error: ErrImagePull
  ```

Then this indicates that the image repository you have specified does not exist on the Docker registry that your cluster is pointed at.

A common list of errors that can cause this are:

- Not specifying the repository (eg myprivaterepository/

- Not specifying the image in full (eg `myimage` instead of `myusername/myimage`)

- Not specifying the tag (eg `myimage` instead of `myimage:1.1`), if the image doesn't have a default `latest` tag

Generally, images will be pulled from the [Docker Hub](https://hub.docker.com/) registry by default. However, it's also possible that your cluster is pointed at another, private registry (or registries)

#### 2.2) Manifest not found

If the error specifies that the manifest is unavailable:

```
Warning  Failed     10m (x4 over 6m)    kubelet, gke-cs-79ec0e47-kfkc  Failed to pull image "nginx:latestt": rpc error: code = Unknown desc = Error response from daemon: manifest for nginx:latestt not found
```

then this indicates that the _specific version_ of the Docker repository is not available. Confirm that the image is available, and update accordingly if this is the case.

#### 2.3) Authorization failed: {#step-2-3}

If the error specifies that authorization failed:

```
Warning  Failed     100s (x4 over 3m6s)  kubelet, dali      Failed to pull image "imiell/bad-dockerfile-private": rpc error: code = Unknown desc = failed to resolve image "docker.io/imiell/bad-dockerfile-private:latest": no available registry endpoint: pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
```
then the container image you have requested may be inaccessible without credentials being supplied; see [Solution A)](#solution-a)

### 3) Check registry is accessible {#step-3}

It may be that there is a network issue between your Kubernetes node and the registry.

To debug this (and if you have admin access), you may need to log into the kubernetes node the container was assigned to (the `/tmp/runbooks_describe_pod.txt` file will have the host name in it) and run the container runtime command to download and run by hand.

## Solutions List {#solutions-list}

A) [Add credentials](#solution-a)

## Solutions Detail {#solutions-detail}

### A) Add credentials {#solution-a}

To access a private repository, you will need to:

- add credentials in a secret

- reference the secret in your pod specification

See [here](https://kubernetes.io/docs/concepts/containers/images/#referring-to-an-imagepullsecrets-on-a-pod) for more information.

## Check Resolution {#check-resolution}

If the pod starts up with status `RUNNING` according to the output of `kubectl get pods`, then the issue has been resolved.

If there is a different status, then it may be that this issue is resolved, but a new issue has been revealed.

## Further Steps {#further-steps}

None

## Further Information {#further-information}

[Kubelet logs](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#looking-at-logs)

[Images documentation](https://kubernetes.io/docs/concepts/containers/images)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)
