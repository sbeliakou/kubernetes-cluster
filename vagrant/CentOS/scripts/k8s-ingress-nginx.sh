#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    Installing Ingress Controller

    - https://github.com/nginxinc/kubernetes-ingress/blob/master/docs/installation.md
    - https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal

================================================================================

END

yum install -y git

cd /tmp/
git clone https://github.com/nginxinc/kubernetes-ingress.git
cd kubernetes-ingress/deployments

kubectl apply -f common/ns-and-sa.yaml
kubectl apply -f common/default-server-secret.yaml
kubectl apply -f common/nginx-config.yaml
kubectl apply -f rbac/rbac.yaml
kubectl apply -f deployment/nginx-ingress.yaml

is_metallb=${1}

if [ "${is_metallb}" == "true" ]; then
  kubectl apply -f service/loadbalancer.yaml
else
  kubectl apply -f service/nodeport.yaml
  IPADDR=$(kubectl get node -l node-role.kubernetes.io/master -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
  kubectl patch svc ingress-nginx -n nginx-ingress --patch '{ "spec": {"externalIPs": [ "'${IPADDR}'" ] }}'
fi

while [ "$(kubectl get pod -n nginx-ingress -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
  echo $(date +"[%H:%M:%S]") Nginx Ingress Controller not Ready
  sleep 10
done

kubectl get pods --all-namespaces -l app==nginx-ingress
kubectl get svc -n nginx-ingress

rm -rf kubernetes-ingress/deployments