#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

    Configuring Kubernetes Master:
      - Pod network: Flannel

================================================================================

END

IPADDR=$1
TOKEN=$2

yum install -y etcd

if [ ! -e /etc/kubernetes/kubelet.conf ]; then
    echo kubeadm init --apiserver-advertise-address ${IPADDR} --token ${TOKEN} --pod-network-cidr 10.244.0.0/16
    kubeadm init \
        --pod-network-cidr 10.244.0.0/16 \
        --apiserver-advertise-address ${IPADDR} \
        --token ${TOKEN}

    mkdir -p $HOME/.kube
    /bin/cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config

    if [ -d /vagrant ]; then
        rm -rf /vagrant/.kube
        /bin/cp -rf $HOME/.kube /vagrant/.kube
    fi
fi