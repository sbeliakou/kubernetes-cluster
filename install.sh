#!/bin/bash

# set -e

export MODE=$1
export IPADDR=$2
export TOKEN=$3

echo "Updating System"
yum update -y

# yum install -y nss-mdns avahi avahi-tools
# systemctl enable avahi-daemon
# systemctl start avahi-daemon

echo "Disabling SELINUX"
getenforce | grep Disabled || setenforce 0
# sed -i 's/\(SELINUX=\).*/\1=disabled/' /etc/sysconfig/selinux
echo "SELINUX=disabled" > /etc/sysconfig/selinux

echo "Installing EPEL REPO and tools"
yum install -y epel-release wget ntp jq net-tools bind-utils

systemctl start ntpd
systemctl enable ntpd

# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
# https://kubernetes.io/docs/setup/independent/install-kubeadm/
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "Installing Docker and Kubernetes"
yum install -y docker runc kubelet kubeadm kubectl kubernetes-cni 

docker_opts="exec-opt"
if [[ "$(docker --version)" =~ 1.12. ]]
then 
    docker_opts="exec-opt"
else
    docker_opts="exec-opts"
fi

cat << EOF > /etc/docker/daemon.json
{
    "${docker_opts}": ["native.cgroupdriver=systemd"]
}
EOF

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

systemctl start docker
systemctl enable docker 
systemctl enable kubelet

# Disable SWAP (As of release Kubernetes 1.8.0, kubelet will not work with enabled swap.)
sed -i 's/[^#]\(.*swap.*\)/# \1/' /etc/fstab
swapoff --all


if [ "${MODE}" == "master" ] && [ -d /etc/kubernetes/manifests ]; then
    
    # Initializing Master
    echo kubeadm init --apiserver-advertise-address ${IPADDR} --token ${TOKEN} --pod-network-cidr 10.244.0.0/16
    kubeadm init \
        --pod-network-cidr 10.244.0.0/16 \
        --apiserver-advertise-address ${IPADDR} \
        --token ${TOKEN}

    mkdir -p $HOME/.kube
    /bin/cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config

    # Installing a Pod Network
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

    # kubectl -n kube-system get ds
    # kubectl -n kube-system get ds -l 'component=kube-proxy' -o json | jq '.items[0].spec.template.spec.containers[0].command |= .+ ["--proxy-mode=userspace"]'
fi

if [ "${MODE}" == "worker" ];
then
    # Joining the Node
    kubeadm join --token #{$token} --discovery-token-unsafe-skip-ca-verification ${IPADDR}:6443
fi

# docker --version
# kubectl version
