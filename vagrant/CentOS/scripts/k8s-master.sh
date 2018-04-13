#!/bin/bash

echo "Executing ${0}"

echo "================================================================"
echo 
echo "Configuring Kubernetes Master:"
echo "  - cluster init"
echo "  - Pod network: Flannel"
echo 
echo "================================================================"

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

    # Installing a Pod Network
    # kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
    # https://github.com/coreos/flannel/blob/master/Documentation/troubleshooting.md#vagrant
    kubectl apply -f /vagrant/configs/kube-flannel.yaml

    # Wait until Master is Up
    while kubectl get nodes | grep master | grep NotReady >/dev/null;
    do
        echo $(date +"[%H:%M:%S]") Master is not ready yet
        sleep 10
    done

    echo $(date +"[%H:%M:%S]") Master is in Ready mode
fi

kubectl get nodes