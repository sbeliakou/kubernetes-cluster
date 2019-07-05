# nodeSelector

- https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector

`nodeSelector` continues to work as usual, but will eventually be deprecated, as node affinity can express everything that `nodeSelector` can express.


## Label the Node

```
kubectl get nodes
kubectl label nodes <node-name> <label-key>=<label-value>
kubectl get nodes --show-labels
kubectl describe node "nodename"
```

```
kubectl label node k8s-worker-1 stack=dev
kubectl label node k8s-worker-2 stack=prod
kubectl describe node k8s-worker-1
```

## Mark a Pod to run on the Node

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: app-dev
  labels:
    env: dev
spec:
  nodeSelector:
    stack: dev
  containers:
  - name: main
    image: busybox
    command:
    - sleep
    - "1000"
EOF
```
```
kubectl get pods -o wide
NAME      READY   STATUS    RESTARTS   AGE    IP           NODE           NOMINATED NODE   READINESS GATES
app-dev   1/1     Running   0          118s   10.244.1.6   k8s-worker-1   <none>           <none>
```