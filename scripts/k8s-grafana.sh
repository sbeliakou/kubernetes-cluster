#!/bin/bash
# https://github.com/kubernetes/heapster/blob/master/docs/influxdb.md 

yum install -y git

cd /tmp/
git clone https://github.com/kubernetes/heapster.git
cd heapster

kubectl create -f deploy/kube-config/influxdb/
kubectl create -f deploy/kube-config/rbac/heapster-rbac.yaml