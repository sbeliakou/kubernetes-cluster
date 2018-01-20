#!/bin/bash
# https://github.com/kubernetes/dashboard

kubectl --kubeconfig /vagrant/.kube/config create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

