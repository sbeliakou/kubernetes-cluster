#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

    Configuring Kubernetes Master in Isolation Mode:
      - taint all nodes to Master
      - adding node-role label: "node"

================================================================================

END

if [ ! -e /etc/kubernetes/.masterisolation ]; then
	kubectl taint nodes --all node-role.kubernetes.io/master-
  kubectl patch node ${HOSTNAME} --patch='{"metadata": {"labels": {"node-role.kubernetes.io/node": ""}}}'
	touch /etc/kubernetes/.masterisolation
fi
