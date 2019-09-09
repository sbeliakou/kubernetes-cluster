#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

    Configuring Kubernetes Master in Isolation Mode:
      - taint all nodes to Master
      - setting node-role: "node"

================================================================================

END

node_status=$(kubectl get nodes ${HOSTNAME} -o yaml | grep node-role.kubernetes.io/node >/dev/null; echo $?)

if [ ${node_status} -ne 0 ]; then
	kubectl taint nodes --all node-role.kubernetes.io/master-
  kubectl label node k8s-master node-role.kubernetes.io/node=
  echo Node Role is Assigned to ${HOSTNAME}
else
  echo Node Role is Already Assigned to ${HOSTNAME}
fi
