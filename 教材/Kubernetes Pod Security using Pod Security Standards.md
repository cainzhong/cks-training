## Kubernetes Pod Security using Pod Security Standards

By Aravind Balasubramanian on Feb 18, 2022

### Overview

Kubernetes is not secure by default and if you are hosting business-critical applications on k8s you need to ensure that they are secure and well protected against malicious threats. Unfortunately, some of these threats can be exploited in an un-secured cluster that can result in a compromise of your systems.

To strengthen your security posture consider what is also known as the 4C’s of cloud-native security - Cloud, Cluster, Containers and Code. This post will cover how you can secure your containers by leveraging a Kubernetes native solution - PodSecurityStandards.

One of the key threats to container security is user and process privilege inside the container. Sometimes a container might genuinely require certain privileges to carry out its operations.

In Kubernetes, `PodSecurityPolicy` and `PodSecurityStandard` are two similar ways of controlling privileges assigned to containers/pods being admitted into a cluster by validating requests to update or create a Pod in a cluster. This is controlled by using policies or security standards which an admission controller within Kubernetes will use for validating requests.

`PodSecurityPolicy` is hard to maintain and confusing to use as it lacks uniformity across large clusters especially when it does not have an audit or dry run mode to test the policies before applying. It is very easy to accidentally grant unnecessary policies that are not intended due to difficulty in verifying them in advance.

Due to various limitations and usability problems, we now know that `PodSecurityPolicy` API (PSP) is being fully deprecated from Kubernetes version 1.25 which means Kubernetes will need a different and more stable solution that Kubernetes provides out of the box. This is where `PodSecurityStandard` admission controller has been introduced and will be generally available from version 1.25 and is currently a beta feature in version 1.23 and available by default.

### What is PodSecurity Standards?

![PSS admission controller](https://innablr.com.au/images/blog/K8s-PSS-controller-diagram.png)

`PodSecurityStandards` are defined in namespaces with admission control modes which helps with consistency and maintainability that the PSP lacks. The pod security standards are however borrowing the security standard levels from PSP and makes it easy to migrate to it. The security standard levels are as follows:

- Privileged - unrestricted and will allow to do things like `hostPID` and `securityContext.privileged=true`
- Baseline - security level prevents privilege escalation and sys-call capabilities amongst other security standard things but will allow common pod setup practices.
- Restricted - no compromise on enforcing any security standards and this might come with the expense of compatibility if things are not setup as expected by the standard.

The profile details are well defined in the official Kubernetes *[documentation](https://kubernetes.io/docs/concepts/security/pod-security-standards/#profile-details)* which will outline what is allowed to be “undefined” and what is required by default in the chosen security level.

### Why `PodSecurityStandards`?

PSPs are being deprecated and there are many reasons why it is being replaced.

- PSPs are bound to users or service accounts with the “use” verb on the policy and it is hard to maintain on large clusters.
- There is no inbuilt ability to warn or audit the policies that will help with testing before rolling out.
- Several third party vendors such as OPA Gatekeeper and Kyverno have addressed PSPs limitations.

It is time for Kubernetes to have out of the box and consistent offering to enforce security profiles to prevent setting up pods with root privileges and other scenarios.

### Advantages of using PodSecurityStandards

`PodSecurityStandards` has a lot of advantages that can be used in conjunction with third party tools like OPA Gatekeeper or Kyverno to provide another layer of policy management.

- It is consistent in deploying the security levels on namespaces by labels which helps with testing, troubleshooting and maintaining.
- Ability to perform dry runs using `--dry-run=server` before applying pod-security on namespace labels. `kubectl label --dry-run=server namespace playground 'pod-security.kubernetes.io/enforce=baseline`
- Provides validations for compliance with policies and will not change the pods to enforce compliance.
- It will be responsive to Pod API evolution across versions and versioning can be enforced by `kubectl label namespace playground 'pod-security.kubernetes.io/enforce-version=v1.23`
- Consists of admission modes such as warn audit and enforce which will be explained in the examples below.

### Demo of PodSecurity Admission controller

For this demo I have set up a Minikube cluster with version 1.23.1 where Pod Security Standards admission controller is available as a default feature.

```shell
  Aravind.Balasubramanian$ minikube start --kubernetes-version=v1.23.1 
  😄  minikube v1.25.1 on Darwin 11.6.1 
  ✨  Using the docker driver based on existing profile 
  👍  Starting control plane node minikube in cluster minikube 
  🚜  Pulling base image ... 
  💾  Downloading Kubernetes v1.23.1 preload ... 
      > preloaded-images-k8s-v16-v1...: 504.42 MiB / 504.42 MiB  100.00% 7.73 MiB 
  🔄  Restarting existing docker container for "minikube" ... 
  🐳  Preparing Kubernetes v1.23.1 on Docker 20.10.12 ... 
      ▪ kubelet.housekeeping-interval=5m 
      ▪ Generating certificates and keys ... 
      ▪ Booting up control plane ... 
      ▪ Configuring RBAC rules ... 
  🔎  Verifying Kubernetes components... 
      ▪ Using image   
  🌟  Enabled addons: storage-provisioner, default-storageclass 
  🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default 
```

Now that the nodes are running with Kubelet version 1.23.1, let us create a namespace for us to experiment the admission controller. Remember that one of the advantages of using `PodSecurityStandards` is its maintainability, hence it works by labelling namespaces which then helps us isolate `baseline`, `privileged` and `restricted` workloads to its own namespaces.

Creating a new namespace to play around with the different modes available with Pod Security Standards

```shell
  Aravind.Balasubramanian$ kubectl create ns playground 
  namespace/playground created 
```

We now label the namespace for the admission controller to set the profiles ( `baseline`, `restricted`, `privileged` ) but with a warning admission mode to try and understand what happens through labelling the namespaces. The other admission modes available are `audit` and `enforce`

```shell
  Aravind.Balasubramanian$ kubectl label namespace playground 'pod-security.kubernetes.io/warn=baseline' 
  namespace/playground labeled
  Aravind.Balasubramanian$ kubectl get namespace playground --show-labels 
  NAME         STATUS   AGE    LABELS 
  playground   Active   3m5s   kubernetes.io/metadata.name=playground,
  pod-security.kubernetes.io/warn=baseline 
```

Lets try to run a `privileged-pod` which is nothing but adding a `securityContext` set to privileged

```yaml
  Aravind.Balasubramanian$ cat privileged-pod.yaml 
  apiVersion: v1 
  kind: Pod 
  metadata: 
    name: privileged-pod 
  spec: 
    containers: 
  name: privileged 
      image: nginx 
      securityContext: 
        privileged: true 
  Aravind.Balasubramanian$ kubectl apply -f privileged-pod.yaml 
  Warning: would violate PodSecurity "baseline:latest": privileged (container "privileged"
  must not set securityContext.privileged=true) 
  pod/privileged-pod created 
```

There! we see a warning for PodSecurity standard’s violation where the container has setup a `securityContext.privileged`

Good that we received a warning for creating a pod which violates `baseline` profile. What happens when you have `enforce` on it ? Let us try it out

```shell
  Aravind.Balasubramanian$ kubectl label namespace playground 'pod-security.kubernetes.io/warn'- 
  namespace/playground labeled 

  Aravind.Balasubramanian$ kubectl label namespace playground \
                           'pod-security.kubernetes.io/enforce=baseline' --overwrite 
  namespace/playground labeled 

  Aravind.Balasubramanian$ kubectl get namespace playground --show-labels 
  NAME         STATUS   AGE   LABELS 
  playground   Active   13m   kubernetes.io/metadata.name=playground,
  pod-security.kubernetes.io/enforce=baseline 
```

We are not allowed to create one !

```shell
  Aravind.Balasubramanian$ kubectl apply -f privileged-pod.yaml 
  Error from server (Forbidden): 
  error when creating "privileged-pod.yaml": pods "privileged-pod" is forbidden: violates PodSecurity 
  "baseline:latest": privileged (container "privileged" must not set securityContext.privileged=true) 
```

### Summary

Container security is one of important foundations in 4C’s of cloud native security and it is often overlooked in application development lifecycle. It is important to design security posture of a system with defence in depth approach as it helps by having thoughtfully layered security controls against many attack vectors. There are many third party tools such as OPA Gatekeeper and Kyverno which are deployed as a Kubernetes admission controller to handle Pod security and it can be used in conjunction with `PodSecurityStandards` to provide a layered approach to pod security.

At Innablr, a Melbourne based Kubernetes Certified Service Provider and leading consultancy for cloud native, Kubernetes, and serverless technologies, we have built battle tested frameworks for safe and secure deployment of Kubernetes. We frequently champion community events, delivering thought leadership and leading practices around securing your cloud environments. We are also recognised in the Australian market as one of the most experienced providers of Kubernetes solutions.

Continuing our successful approach of building repeatable and extensible frameworks, Innablr has built a blueprint for Google Cloud and Amazon Web Services Kubernetes deployment whether it is Google Kubernetes Engine (GKE) or Elastic Kubernetes Service (EKS).

To learn more about how we’ve been helping businesses innovate with Kubernetes, see our [Kubernetes Certified Solution Provider](https://innablr.com.au/kubernetes-certified/) page.

*[Aravind Balasubramanian](https://www.linkedin.com/in/aravind-nagaraj/), Engineer @ Innablr*

> **Reference**
>
> https://innablr.com.au/blog/how-to-secure-kubernetes-workloads-using-pod-security-standards/





## Pod Security Standards (PSS): All You Need to Know

**Privileged:** An unrestricted (unsecured) policy that grants the greatest permissible level of access. This policy allows for well-documented privilege escalation. It’s the lack of a policy. This is useful for logging agents, CNIs, storage drivers, and other system-wide programs that require privileged access.

**Baseline:** A policy that is as restrictive as possible while preventing known privilege escalation. Allows for the use of the default (minimally stated) Pod configuration. The baseline policy forbids the usage of hostNetwork, hostPID, hostIPC, hostPath, and hostPort, as well as the ability to add Linux capabilities, among other things.

**Restricted:** Strict policy that adheres to current Pod hardening best practices. This policy builds on the baseline and adds additional constraints, such as the inability to operate as a root or a root-group. Restricted policies can have an effect on an application’s capacity to function. They are particularly intended for the execution of security-critical applications.

> **Reference**
>
> https://k21academy.com/docker-kubernetes/pod-security-standards-pss/