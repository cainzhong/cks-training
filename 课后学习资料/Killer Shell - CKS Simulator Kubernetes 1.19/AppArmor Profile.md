# AppArmor Profile

**AppArmor** ("Application Armor") is a [Linux kernel](https://en.wikipedia.org/wiki/Linux_kernel) [security module](https://en.wikipedia.org/wiki/Linux_Security_Modules) that allows the system administrator to restrict programs' capabilities with per-program profiles. Profiles can allow capabilities like network access, raw socket access, and the permission to read, write, or execute files on matching paths. 

```
# /opt/course/9/profile 

#include <tunables/global>
profile very-secure flags=(attach_disconnected) {
  #include <abstractions/base>

  file,
  
  # Deny all file writes.
  deny /** w,
}
```

## Install the AppArmor profile on *Node* `ubuntu-k8s-node1`

```shell
apparmor_parser ./profile
```

## Verify AppArmor profile `very-secure` has been installed.

```
apparmor_status | grep very-secure
```

## Restrict a Container's Access to Resources with AppArmor

```shell
kubectl create -f answer_question9_apparmor_profile.yaml
```

```yaml
# kubectl create deployment apparmor --image=nginx:1.19.2 --dry-run=client -o yaml > apparmor-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: apparmor
  name: apparmor
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apparmor
  template:
    metadata:
      labels:
        app: apparmor
      annotations:                                                                    # add
        container.apparmor.security.beta.kubernetes.io/c1: localhost/very-secure      # add
    spec:
      containers:
      - image: nginx:1.19.2
        name: c1                # change
      nodeSelector:             # add
        security: apparmor      # add
```

### Verify

```shell
root@ubuntu-k8s-master1:/home/sftpuser# kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
apparmor-85c65645dc-tq5gz   0/1     Error     5          3m7s

root@ubuntu-k8s-master1:/home/sftpuser# kubectl logs apparmor-85c65645dc-tq5gz 
/docker-entrypoint.sh: 13: /docker-entrypoint.sh: cannot create /dev/null: Permission denied
/docker-entrypoint.sh: No files found in /docker-entrypoint.d/, skipping configuration
2021/01/23 11:22:04 [emerg] 1#1: mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
```



> 参考资料：
>
> https://kubernetes.io/docs/tutorials/clusters/apparmor/