## Upgrading from 1.13.7 to 1.14.3

- https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade-1-14/

### Check Client and Server Versions
```
$ kubectl version --short
Client Version: v1.14.3
Server Version: v1.13.7
```

### Find the latest stable 1.14 version
```
$ yum list --showduplicates kubeadm
kubeadm.x86_64           1.13.7-0              kubernetes
kubeadm.x86_64           1.14.0-0              kubernetes
kubeadm.x86_64           1.14.1-0              kubernetes
kubeadm.x86_64           1.14.2-0              kubernetes
kubeadm.x86_64           1.14.3-0              kubernetes
kubeadm.x86_64           1.15.0-0              kubernetes
```

### Upgrade Control Plane Node(s)

1. Upgrade kubeadm
```
$ yum install -y kubeadm-1.14.3-0 --disableexcludes=kubernetes
$ kubeadm version
```

2. Check Upgrade Plan
```
$ kubeadm upgrade plan
...
COMPONENT            CURRENT   AVAILABLE
API Server           v1.13.7   v1.14.3
Controller Manager   v1.13.7   v1.14.3
Scheduler            v1.13.7   v1.14.3
Kube Proxy           v1.13.7   v1.14.3
CoreDNS              1.2.6     1.3.1
Etcd                 3.2.24    3.3.10

You can now apply the upgrade by executing the following command:

  kubeadm upgrade apply v1.14.3
...
```

3. Upgrade Control Plane
```
$ kubeadm upgrade apply v1.14.3
...
[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.14.3". Enjoy!
...
```

4. Manually upgrade your CNI provider plugin.

5. Upgrade the kubelet and kubectl on the control plane node
```
$ yum install -y kubelet-1.14.3-0 kubectl-1.14.3-0
$ systemctl daemon-reload
$ systemctl restart kubelet
```

6. Checking
```
$ kubectl version --short
Client Version: v1.14.3
Server Version: v1.14.3

$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master     Ready    master   27m   v1.14.3
k8s-worker-1   Ready    node     22m   v1.13.7
```


### Upgrade Worker Node(s)

1. Upgrade Kubeadm
```
$ yum install -y kubeadm-1.14.3
```

2. Prepare the node for maintenance by marking it unschedulable and evicting the workloads
```
$ kubectl drain $HOSTNAME --ignore-daemonsets --delete-local-data
node/k8s-worker-1 cordoned
WARNING: Ignoring DaemonSet-managed pods: kube-flannel-ds-amd64-d29pz, kube-proxy-cj657, speaker-brtfk; Deleting pods with local storage: kubernetes-dashboard-57df4db6b-kl7mm
pod/coredns-fb8b8dccf-jcvc4 evicted
pod/nginx-ingress-755df5c4cc-z4dg8 evicted
pod/kubernetes-dashboard-57df4db6b-kl7mm evicted
node/k8s-worker-1 evicted
```

3. Upgrade Kubelet Config
```
$ kubeadm upgrade node config --kubelet-version v1.14.3
[kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.14" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade] The configuration for this node was successfully updated!
[upgrade] Now you should go ahead and upgrade the kubelet package using your package manager.
```

4. Upgrade kubelet and kubectl
```
$ yum install -y kubelet-1.14.3-0 kubectl-1.14.3-0
$ systemctl daemon-reload
$ systemctl restart kubelet
```

5. Uncordon the node
```
$ kubectl uncordon $HOSTNAME
node/k8s-worker-1 uncordoned
```

6. Checking
```
$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master     Ready    master   27m   v1.14.3
k8s-worker-1   Ready    node     22m   v1.14.3