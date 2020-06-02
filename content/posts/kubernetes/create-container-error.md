---
title: "CreateContainerError"
summary: "Pod failing with CreateContainerError"
---

## Overview {#overview}

This issue happens when... TODO

## Check RunBook Match {#check-runbook-match}

When you ... you expect to see ...

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

Look at the 'Events' section of your `/tmp/runbooks_describe_pod.txt` file.

#### 2.1) If you see `no command specified`

TODO

```
Warning  Failed     116s                kubelet, dali      Error: failed to generate container "be3707fcf873ecc052ff73d3ffe7ed3a51eec0756b84839f908f7c9ab730ae74" spec: no command specified
```

## Solutions {#solutions}

TODO

A) [Solution](#solution-a)

### Solution A {#solution-a}

## Check Resolution {#check-resolution}

TODO

## Further Steps {#further-steps}

TODO

1) [Further Step 1](#further-steps-1)

### Further Step 1 {#further-steps-1}

TODO

## Further Information {#further-information}

[//]: # (REFERENCED DOCS)
[//]: # (https://discuss.kubernetes.io/t/failed-job-pod-container-troubleshooting/6144 TODO)
[//]: # (https://bugzilla.redhat.com/show_bug.cgi?id=1537478)
[//]: # (https://github.com/cri-o/cri-o/issues/1927 TODO)
[//]: # (https://github.com/cri-o/cri-o/issues/815 TODO)
[//]: # (https://stackoverflow.com/questions/57143214/about-createcontainererror TODO)
[//]: # (https://stackoverflow.com/questions/57476752/kube-apiserver-pod-sticks-in-the-createcontainererror-status TODO)
[//]: # (https://stackoverflow.com/questions/58390812/how-to-fix-kubernetes-create-container-error TODO)
[//]: # (https://stackoverflow.com/questions/61350893/kubernetes-gcp-error-response-from-daemon-no-command-specified-createcontainer TODO)
[//]: # (https://stackoverflow.com/questions/50424754/pod-status-as-createcontainerconfigerror-in-minikube-cluster TODO)
[//]: # (https://stackoverflow.com/questions/57821723/list-of-all-reasons-for-container-states-in-kubernetes TODO)
[//]: # ()
[//]: # ()
[//]: # ()
[//]: # ()
