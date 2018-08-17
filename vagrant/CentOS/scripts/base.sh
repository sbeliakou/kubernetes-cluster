#!/bin/bash

echo "Executing ${0}"

yum install -y deltarpm

yum update -y

# yum install -y nss-mdns avahi avahi-tools
# systemctl enable avahi-daemon
# systemctl start avahi-daemon

echo "================================================================"
echo 
echo "Disabling SELINUX"
echo 
echo "================================================================"
getenforce | grep Disabled || setenforce 0
echo "SELINUX=disabled" > /etc/sysconfig/selinux

echo "================================================================"
echo 
echo "Disabling SWAP"
echo 
echo "================================================================"

# Disable SWAP (As of release Kubernetes 1.8.0, kubelet will not work with enabled swap.)
sed -i 's/[^#]\(.*swap.*\)/# \1/' /etc/fstab
swapoff --all

echo "================================================================"
echo 
echo "Installing Dependencies:"
echo "  - epel-release"
echo "  - wget"
echo "  - ntp"
echo "  - jq"
echo "  - net-tools"
echo "  - bind-utils"
echo "  - moreutils"
echo 
echo "================================================================"

echo "Installing EPEL REPO and tools"
yum install -y epel-release wget ntp jq net-tools bind-utils moreutils

systemctl start ntpd
systemctl enable ntpd

# Installing Docker CE
# https://docs.docker.com/install/linux/docker-ce/centos/#install-docker-ce

echo "================================================================"
echo 
echo "Installing Docker CE:"
echo "   yum install -y yum-utils device-mapper-persistent-data lvm2"
echo "   yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"
echo "   yum-config-manager --enable docker-ce-edge"
echo "   yum install -y docker-ce runc"
echo 
echo "================================================================"

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yum install -y docker-ce runc

systemctl enable docker 

echo "================================================================"
echo 
echo "Configuring Docker Daemon"
echo 
echo "================================================================"

mkdir -p /etc/docker

docker info | grep "Cgroup Driver: systemd"
if [ $? -ne 0 ]; then
    echo "Updating Docker settings"
    if [ -f /etc/docker/daemon.json ]; then
        cat /etc/docker/daemon.json | \
            jq '."exec-opts" |= .+ ["native.cgroupdriver=systemd"]' | \
            sponge /etc/docker/daemon.json
    else
        echo "{}" | \
        jq '."exec-opts" |= .+ ["native.cgroupdriver=systemd"]' > \
        /etc/docker/daemon.json
    fi
    echo "CAT /etc/docker/daemon.json:"
    cat /etc/docker/daemon.json
    echo 
    systemctl restart docker || exit 1
fi

cat <<EOF >  /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo "================================================================"
echo 
echo "Installing Kubernetes:"
echo "  - kubelet"
echo "  - kubeadm"
echo "  - kubectl"
echo "  - kubernetes-cni "
echo 
echo "================================================================"

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

echo "Installing Kubernetes"
yum install -y kubelet kubeadm kubectl kubernetes-cni 

systemctl start docker
systemctl enable kubelet

# Fix 'error: unable to upgrade connection: pod does not exist'
sed -i "s/\(KUBELET_EXTRA_ARGS=\).*/\1--node-ip=$(ifconfig enp0s8 | sed -n '2p' | awk '{print $2}')/" /etc/sysconfig/kubelet

# yum install -y dnsmasq
# cat <<EOF > /etc/dnsmasq.d/10-kub-dns
# server=/svc.cluster.local/10.96.0.10#53
# listen-address=127.0.0.1
# bind-interfaces
# EOF

# systemctl start dnsmasq
# systemctl enable dnsmasq