#!/bin/bash

# https://github.com/kubernetes/ingress-nginx/tree/master/deploy

echo "Executing ${0}"

echo "================================================================"
echo 
echo "Configuring Ingress Controller:"
echo "  - ingress Controller Namespace"
echo "  - default backend"
echo "  - configmap (tcp/udp)"
echo "  - rbac"
echo "  - node port"
echo "  - patch entrypoint to ${IPADDR}"
echo 
echo "================================================================"

export IPADDR=$1

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/with-rbac.yaml 

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml

kubectl patch svc ingress-nginx -n ingress-nginx --patch '{ "spec": {"externalIPs": [ "'${IPADDR}'" ] }}'

kubectl get pods -n ingress-nginx 