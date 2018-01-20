### Local Kubernetes Environment on Vagrant/Virtualbox and CentOS 7

## HOW TO
- [Config File](config.rb)
- [Vagrantfile](Vagrantfile)

```
$ vagrant up
$ vagrant ssh k8s-master
$ vagrant ssh k8s-worker-1 # k8s-worker-{N}
$ kubectl --kubeconfig .kube/config proxy
$ vagrant destroy
```

## Tested on:
- VirtualBox 5.2.6
- Vagrant 2.0.1
- CentOS 7.4
- Docker 1.12.6
- Kubernetes 1.9.2
- Flannel 0.9.1

## Supported Configurations
- Master + Workers (worker_count > 0)
- Master Isolation (worker_count = 0)

## Deployed Applications/Services
- [x] Kubernetes Dashboard
- [x] Grafana + InfluxDB
- [ ] Ingress Controller
- [ ] Applications Deployment
- [ ] Helm Tiller
- [ ] Prometheus

## Used Documentation

# Basic Installation and Configuration
- https://kubernetes.io/docs/setup/independent/install-kubeadm/
- https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

# A Pod Network (Flannel)
- https://github.com/coreos/flannel
- https://github.com/coreos/flannel/blob/master/Documentation/troubleshooting.md#vagrant

# Kubernetes Dashboard
- https://github.com/kubernetes/dashboard
- https://github.com/kubernetes/dashboard/wiki/Creating-sample-user

# Grafana and InfluxDB
- https://github.com/kubernetes/heapster
- https://github.com/kubernetes/heapster/blob/master/docs/influxdb.md
- https://kubernetes.io/docs/tasks/run-application/update-api-object-kubectl-patch/

# Ingress Controller
- https://kubernetes.io/docs/concepts/services-networking/ingress/
- https://github.com/kubernetes/ingress-gce/blob/master/BETA_LIMITATIONS.md#glbc-beta-limitations

# Other
- https://kubernetes.io/docs/tasks/access-kubernetes-api/http-proxy-access-api/

## Fixes & Work Arounds
- [VirtualBox NAT Interface](Vagrantfile#L21)
- [VirtualBox CPU Usage](Vagrantfile#L22)
- [Flannel + VirtualBox](configs/kube-flannel.yaml#L111)
