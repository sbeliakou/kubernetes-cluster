# Affinity

- https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity

The affinity feature consists of two types of affinity:
- “node affinity” (like nodeSelector)
- “inter-pod affinity/anti-affinity”

Benefits:
1. the language is more expressive (not just “AND of exact match”)
2. you can indicate that the rule is “soft”/“preference” rather than a hard requirement, so if the scheduler can’t satisfy it, the pod will still be scheduled
3. you can constrain against labels on other pods running on the node (or other topological domain), rather than against labels on the node itself, which allows rules about which pods can and cannot be co-located

## Node affinity

There are currently two types of node affinity:
- requiredDuringSchedulingIgnoredDuringExecution (hard, must)
- preferredDuringSchedulingIgnoredDuringExecution (soft, preferences that the scheduler will try to enforce but will not guarantee)


```
cat <<eof | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity-hard
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: stack
            operator: In
            values:
            - dev
            - stage
  containers:
  - name: with-node-affinity
    image: k8s.gcr.io/pause:2.0
eof
```

```
kubectl label node k8s-worker-1 region west-1
kubectl label node k8s-worker-2 region west-2

cat <<eof | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: with-node-affinity-soft
spec:
  replicas: 10
  selector:
    matchLabels:
      app: with-node-affinity-soft
  template:
    metadata:
      labels:
        app: with-node-affinity-soft
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 9
            preference:
              matchExpressions:
              - key: region
                operator: In
                values:
                - west-1
          - weight: 1
            preference:
              matchExpressions:
              - key: region
                operator: In
                values:
                - west-2
      containers:
      - name: with-node-affinity
        image: k8s.gcr.io/pause:2.0
eof
```

9 pods running on k8s-worker-1
1 pod running on k8s-worker-2
