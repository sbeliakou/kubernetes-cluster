#!/bin/bash


cat <<END
Executing ${0}
================================================================================

    https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

    Configuring Kubernetes Master:
      - Pod network: Flannel

================================================================================

END

export KUBECONFIG=/etc/kubernetes/admin.conf

# Installing a Pod Network
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
# https://github.com/coreos/flannel/blob/master/Documentation/troubleshooting.md#vagrant
IPETHX=$(ip r | grep $(hostname -I | sed 's/10.0.2.15//' | awk '{print $1}') | cut -d' ' -f3)
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.11.0/Documentation/kube-flannel.yml
kubectl patch daemonsets kube-flannel-ds-amd64 -n kube-system --patch '{
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "name": "kube-flannel", 
                        "args": [
                            "--ip-masq",
                            "--kube-subnet-mgr",
                            "--iface='${IPETHX}'"
                        ]
                    }
                ]
            }
        }
    }
}'

kubectl get daemonsets -n kube-system kube-flannel-ds-amd64

while kubectl get nodes | grep master | grep NotReady >/dev/null;
do
    echo $(date +"[%H:%M:%S]") Master is not ready yet
    sleep 10
done

echo $(date +"[%H:%M:%S]") Master is in Ready mode