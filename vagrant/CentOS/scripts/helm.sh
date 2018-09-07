#!/bin/bash

echo "Executing ${0}"

echo "=== Creating Cluster Role ==="
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default

echo "====== Installing HELM ======"
export HELM_RELEASE=2.10.0
echo "Helm Version to be Installed: ${HELM_RELEASE}"
wget -qO- https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_RELEASE}-linux-amd64.tar.gz | tar xvz linux-amd64/helm --to-stdout > /usr/bin/helm
chmod a+x /usr/bin/helm

helm init
while [[ -z "$(helm version | grep Server)" ]]
do
	sleep 1
done

helm version