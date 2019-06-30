## Documentation References

### Kubernetes Architecture
- https://github.com/kubernetes/community/blob/master/contributors/design-proposals/architecture/architecture.md
- https://github.com/kubernetes/kubernetes/blob/release-1.5/docs/design/architecture.md
- https://github.com/kubernetes/kubernetes/blob/release-1.5/docs/design/clustering.md
- https://kubernetes.io/docs/concepts/overview/components/
- https://kubernetes.io/docs/concepts/architecture/cloud-controller/

### Basic Installation and Configuration
- https://kubernetes.io/docs/setup/independent/install-kubeadm/
- https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
- https://kubernetes.io/docs/setup/independent/troubleshooting-kubeadm/

### A Pod Network Addon (CNI)
- [Flannel](https://github.com/coreos/flannel)
- [Flannel Vagrant Settings](https://github.com/coreos/flannel/blob/master/Documentation/troubleshooting.md#vagrant)
- [Weave](https://www.weave.works/docs/net/latest/kubernetes/kube-addon/)

### Kubernetes Objects (Kinds) and Operations
Primitives:

- [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)
- [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)

Controllers:

- [ReplicationController](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/)
- [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- [HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

Volumes:

- [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
- [PV/PVC Walkthrough](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)

### Kubernetes Dashboard
- https://github.com/kubernetes/dashboard
- https://github.com/kubernetes/dashboard/wiki/Creating-sample-user

### Grafana and InfluxDB
- https://github.com/kubernetes/heapster
- https://github.com/kubernetes/heapster/blob/master/docs/influxdb.md
- https://kubernetes.io/docs/tasks/run-application/update-api-object-kubectl-patch/

### Ingress Controller
- https://kubernetes.io/docs/concepts/services-networking/ingress/
- https://github.com/kubernetes/ingress-gce/blob/master/BETA_LIMITATIONS.md#glbc-beta-limitations
- https://github.com/kubernetes/ingress-nginx/tree/master/deploy
- https://github.com/nginxinc/kubernetes-ingress/blob/master/examples/multiple-ingress-controllers/README.md

### Kubernetes Storage
- https://kubernetes.io/docs/concepts/storage/volumes/
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/

### Kubernetes Tutorials
- https://kubernetes.io/docs/tutorials/
- http://katacoda.com/courses/kubernetes
- https://www.edx.org/course/introduction-kubernetes-linuxfoundationx-lfs158x?gclid=EAIaIQobChMI06mUq96K2QIViKMYCh0B6wl9EAMYASAAEgKRFfD_BwE

### Other
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://github.com/Praqma/LearnKubernetes/blob/master/kamran/Kubernetes-kubectl-cheat-sheet.md
- http://design.jboss.org/redhatdeveloper/marketing/kubernetes_cheatsheet/cheatsheet/cheat_sheet/images/kubernetes_cheat_sheet_r1v1.pdf
- https://kubernetes.io/docs/tasks/access-kubernetes-api/http-proxy-access-api/
- http://hyperpolyglot.org/json

## Fixes & Work Arounds
- [VirtualBox NAT Interface](vagrant/CentOS/Vagrantfile#L21)
- [VirtualBox CPU Usage](vagrant/CentOS/Vagrantfile#L22)
- [Flannel + VirtualBox](configs/kube-flannel.yaml#L111)