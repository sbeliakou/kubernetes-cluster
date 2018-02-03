#!/bin/bash

yum install -y deltarpm

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

cat << EOF > /etc/docker/daemon.json
{
    "$([[ $(docker --version) =~ 1.12. ]] && echo exec-opt || echo exec-opts)": ["native.cgroupdriver=systemd"]
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
echo "Disabling SWAP"
sed -i 's/[^#]\(.*swap.*\)/# \1/' /etc/fstab
swapoff --all


# yum install -y dnsmasq
# cat <<EOF > /etc/dnsmasq.d/10-kub-dns
# server=/svc.cluster.local/10.96.0.10#53
# listen-address=127.0.0.1
# bind-interfaces
# EOF

# systemctl start dnsmasq
# systemctl enable dnsmasq