# Taints and Tolrations

- https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/

```
kubectl taint nodes node1 key=value:NoSchedule
kubectl taint nodes node1 key:NoSchedule-
```

```
kubectl taint nodes k8s-worker-2 key=prod:NoSchedule
kubectl taint nodes k8s-worker-2 key=prod:NoExecute
```

kubectl taint node ip-10-0-1-102 key=prod:NoSchedule
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prod
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prod
  template:
    metadata:
      labels:
        app: prod
      spec:
        containers:
        - name: prod
          image: k8s.gcr.io/pause:2.0
        tolerations:
        - key: key
          operator: Equal
          value: prod
          effect: NoSchedule
```