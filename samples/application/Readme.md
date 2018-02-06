## Typical Application Configuration


```
    internet -> [ ingress-controller ] -> [ service ] -> [ pods ]
```

```
$ kubectl apply -f /vagrant/samples/application/application.yaml

$ kubectl get ing
NAME                      HOSTS                                ADDRESS   PORTS     AGE
web-application-ingress   web-application.kubernetes.example             80        29m

$ kubectl describe ing web-application-ingress
Name:             web-application-ingress
Namespace:        default
Address:
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host                                Path  Backends
  ----                                ----  --------
  web-application.kubernetes.example
                                      /   web-application-svc:80 (<none>)
Annotations:
Events:
  Type    Reason  Age   From                      Message
  ----    ------  ----  ----                      -------
  Normal  CREATE  29m   nginx-ingress-controller  Ingress default/web-application-ingress
  Normal  UPDATE  28m   nginx-ingress-controller  Ingress default/web-application-ingress


$ kubectl get svc web-application-svc
NAME                  TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
web-application-svc   NodePort   10.103.226.204   <none>        80:30080/TCP   1h

$ kubectl get pods -n ingress-nginx
NAME                                       READY     STATUS    RESTARTS   AGE
default-http-backend-55c6c69b88-n7h4h      1/1       Running   1          2d
nginx-ingress-controller-f8bdfcb68-xmkn5   1/1       Running   0          21m

$ kubectl exec -n ingress-nginx $(kubectl get pods -n ingress-nginx | grep nginx-ingress-controller | awk '{print $1}') cat /etc/nginx/nginx.conf

$ kubectl logs -n ingress-nginx $(kubectl get pods -n ingress-nginx | grep nginx-ingress-controller | awk '{print $1}')

$ curl -H "Host: web-application.kubernetes.example" 192.168.56.150
```

```
kubectl apply -f nginx.yaml --record
kubectl get deploy
kubectl rollout status deploy nginx
kubectl get rs
kubectl get pods -o wide
kubectl describe deploy/nginx
```

## Sample Statful Application

Stack: [nginx-pv](nginx-pv.yaml)

```
$ kubectl get nodes --show-labels
NAME           STATUS    ROLES     AGE       VERSION   LABELS
k8s-master     Ready     master    20h       v1.9.2    beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=k8s-master,node-role.kubernetes.io/master=
k8s-worker-1   Ready     <none>    20h       v1.9.2    beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=k8s-worker-1,team=mtp,tool=jenkins
k8s-worker-2   Ready     <none>    20h       v1.9.2    beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=k8s-worker-2

$ kubectl apply -f samples/application/nginx-pv.yaml
namespace "devops-ns" created
persistentvolume "web-application-pv" created
persistentvolumeclaim "web-application-pvc" created
deployment "web-application-deployment" created
service "web-application-svc" created
ingress "web-application-ingress" created

$ kubectl rollout status deployment web-application-deployment -n devops-ns
Waiting for rollout to finish: 0 of 1 updated replicas are available...
deployment "web-application-deployment" successfully rolled out

$ curl -H "Host: web-application.kubernetes.example" 192.168.56.150
Hello from Kubernetes storage (init container)

$ kubectl describe pod $(kubectl get po -n devops-ns | awk '/web-application/{print $1}') -n devops-ns
```