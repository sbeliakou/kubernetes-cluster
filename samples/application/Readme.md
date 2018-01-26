## Typical Application Configuration

```
    [ ingress]
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

$ kubectl exec -n ingress-nginx -ti nginx-ingress-controller-f8bdfcb68-xmkn5 cat /etc/nginx/nginx.conf
$ curl -H "Host: web-application.kubernetes.example" 192.168.56.150
```