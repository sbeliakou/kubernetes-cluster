#!/bin/bash

# https://github.com/kubernetes/dashboard
# https://github.com/kubernetes/dashboard/wiki/Creating-sample-user

echo "Executing ${0}"

echo "================================================================"
echo 
echo "Installing Dashboard:"
echo "  - dashboard"
echo "  - admin user"
echo 
echo "================================================================"

dash=$(kubectl get deployments --all-namespaces | grep kubernetes-dashboard >/dev/null; echo $?)
if [ $dash -ne 0 ]; then 
    echo "Deploying Dashboard"
    kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    kubectl create -f ${CONFIGS_DIR}/admin-user.yaml
fi

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

cat << EOF
For Accessing Kub Dashboard:
    1. kubectl --kubeconfig .kube/config proxy --address='0.0.0.0' --accept-hosts='^*$'
    2. In browser go to: http://localhost:8001/ui/
    3. Sign in with above mentioned token
    
EOF
