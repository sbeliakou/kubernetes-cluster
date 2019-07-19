- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/


kubectl create configmap appconfig --from-literal=key1=value1 --from-literal=key2=value2
kubectl get configmap appconfig -o yaml

