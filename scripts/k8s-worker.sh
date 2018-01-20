#!/bin/bash

IPADDR=$1
TOKEN=$2

if [ ! -e /etc/kubernetes/kubelet.conf ]; then
    echo kubeadm join --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification ${IPADDR}:6443
    kubeadm join --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification ${IPADDR}:6443

    while kubectl --kubeconfig /vagrant/.kube/config get nodes | grep $(hostname) | grep NotReady >/dev/null;
    do
        echo $(date +"[%H:%M:%S]") Worker $(hostname) is not ready yet
        sleep 10
    done

    echo $(date +"[%H:%M:%S]") Worker $(hostname) is in Ready mode

    mkdir -p $HOME/.kube
    /bin/cp -f /vagrant/.kube/config $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
fi

kubectl get nodes