#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    Installing Ingress Controller

    - https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md
    - https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/baremetal.md
    - https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal

================================================================================

END

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

version="nginx-0.24.1"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/${version}/deploy/mandatory.yaml

is_metallb=${1}

if [ "${is_metallb}" == "true" ]; then
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/${version}/deploy/provider/cloud-generic.yaml
else
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/${version}/deploy/provider/baremetal/service-nodeport.yaml
  IPADDR=$(kubectl get node -l node-role.kubernetes.io/master -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
  kubectl patch svc ingress-nginx -n ingress-nginx --patch '{ "spec": {"externalIPs": [ "'${IPADDR}'" ] }}'
fi

while [ "$(kubectl get pod -n ingress-nginx -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
  echo $(date +"[%H:%M:%S]") Nginx Ingress Controller not Ready
  sleep 10
done

kubectl get svc -n ingress-nginx