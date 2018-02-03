#!/bin/bash

# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

if [ ! -e /etc/kubernetes/.masterisolation ]; then
	kubectl taint nodes --all node-role.kubernetes.io/master-
	touch /etc/kubernetes/.masterisolation
fi
