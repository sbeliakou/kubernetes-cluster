#!/bin/bash

cat <<END
Executing ${0}
================================================================================
    Installing Ingress Controller
    - https://github.com/nginxinc/kubernetes-ingress/blob/master/docs/installation.md
    - https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal
================================================================================
END

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.25.0/deploy/static/mandatory.yaml

NGINX_NS="ingress-nginx"
is_metallb=${1}

if [ "${is_metallb}" == "true" ]; then
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.25.0/deploy/static/provider/cloud-generic.yaml
else
  IPADDR=$(kubectl get node -l node-role.kubernetes.io/master -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.25.0/deploy/baremetal/service-nodeport.yaml
  kubectl patch svc ingress-nginx -n ${NGINX_NS} --patch '{
    "spec": {
      "externalIPs": [
        "'${IPADDR}'"
      ]
    }
  }'
fi

while [ "$(kubectl get pod -n ${NGINX_NS} -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
  echo $(date +"[%H:%M:%S]") Nginx Ingress Controller not Ready
  sleep 10
done

# kubectl get pods --all-namespaces -l app==nginx-ingress
kubectl get svc -n ${NGINX_NS}

# rm -rf kubernetes-ingress/deployments