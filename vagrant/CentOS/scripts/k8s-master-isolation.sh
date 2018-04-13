#!/bin/bash

# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

echo "Executing ${0}"
echo "================================================================"
echo 
echo "Configuring Kubernetes Master in Isolation Mode:"
echo "  - taint all nodes to Master"
echo 
echo "================================================================"


if [ ! -e /etc/kubernetes/.masterisolation ]; then
	kubectl taint nodes --all node-role.kubernetes.io/master-
	touch /etc/kubernetes/.masterisolation
fi
