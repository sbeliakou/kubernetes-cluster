#!/bin/bash

# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

kubectl taint nodes --all node-role.kubernetes.io/master-