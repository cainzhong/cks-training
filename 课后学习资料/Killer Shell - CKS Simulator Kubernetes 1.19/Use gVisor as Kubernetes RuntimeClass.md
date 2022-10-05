# Use gVisor as Kubernetes RuntimeClass

## Install runsc & containerd-shim-runsc-v1

To download and install the latest release manually follow these steps:

```shell
ARCH=$(uname -m)
URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}
wget ${URL}/runsc ${URL}/runsc.sha512 ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512
sha512sum -c runsc.sha512 -c containerd-shim-runsc-v1.sha512
rm -f *.sha512
chmod a+rx runsc containerd-shim-runsc-v1
sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin
```

## Configure containerd

Update `/etc/containerd/config.toml`.

```shell
cat <<EOF | sudo tee /etc/containerd/config.toml
disabled_plugins = ["restart"]
[plugins.linux]
  shim_debug = true
[plugins.cri.containerd.runtimes.runsc]
  runtime_type = "io.containerd.runsc.v1"
EOF
```

Restart `containerd`:

```shell
sudo systemctl restart containerd
```

## Set up the Kubernetes RuntimeClass

Install the RuntimeClass for gVisor:

```
cat <<EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1beta1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
EOF
```

Create a Pod with the gVisor RuntimeClass:

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-gvisor
spec:
  runtimeClassName: gvisor
  containers:
  - name: nginx
    image: nginx:1.19.2
EOF
```

Verify that the Pod is running:

```shell
root@ubuntu-k8s-master1:/home/sftpuser# kubectl exec -it nginx-gvisor -- dmesg
[    0.000000] Starting gVisor...
[    0.240987] Checking naughty and nice process list...
[    0.525185] Constructing home...
[    0.785101] Accelerating teletypewriter to 9600 baud...
[    1.126662] Verifying that no non-zero bytes made their way into /dev/zero...
[    1.616683] Consulting tar man page...
[    1.823984] Generating random numbers by fair dice roll...
[    2.291683] Recruiting cron-ies...
[    2.684354] Moving files to filing cabinet...
[    2.799629] Letting the watchdogs out...
[    2.900680] Granting licence to kill(2)...
[    2.924301] Ready!
```

> 参考资料：
>
> https://gvisor.dev/docs/user_guide/containerd/quick_start/
>
> https://gvisor.dev/docs/user_guide/install/

