# Kubernetes User Management

Kubernetes doesn’t manage users. Normal users are assumed to be managed by an outside, independent service like LDAP or Active Directory. In a standard installation of Kubernetes (i.e., using kubeadm), authentication is done via standard transport level security (TLS) certificates.

Any user that presents a valid certificate signed by the cluster’s certificate authority (CA) is considered authenticated. In this configuration, Kubernetes determines the username from the common name field in the ‘subject’ of the cert (e.g., "/CN=jj"). From there, the role based access control (RBAC) sub-system would determine whether the user is authorized to perform a specific operation a resource.


## Provising Access to the Cluster

The first step is to create a key and certificate signing request (CSR) for JJ’s access to the cluster using `openssl`:
```
openssl req -new -newkey rsa:2048 -nodes -days 3650 \
    -subj "/C=BY/ST=Minsk/L=Minsk/O=John James Corp PLC/OU=IT/CN=jj" \
    -keyout jj.key \
    -out jj.csr
```

Now that we have a CSR, we need to have it signed by the cluster CA. For that, we create a CertificateSigningRequest object within Kubernetes containing the CSR we generated above. For this, I use a 'template' CSR manifest and a neat trick using the --edit parameter to `kubectl` that allows you to edit the manifest before submitting it to the API server:
```
cat << EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: jj-developer
spec:
  request: $(cat jj.csr | base64 | tr -d '\n')
  groups:
  - system:authenticated
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
EOF
```

Once the CSR has been created, it enters a 'PENDING' condition as seen from the output below:
```
kubectl get csr
NAME           AGE   REQUESTOR          CONDITION
jj-developer   11s   kubernetes-admin   Pending
```

Then we should approve this request:
```
kubectl certificate approve jj-developer
certificatesigningrequest.certificates.k8s.io/jj-developer approved

kubectl get csr
NAME           AGE   REQUESTOR          CONDITION
jj-developer   14s   kubernetes-admin   Approved,Issued
```

## Generating KUBECONFIG file for user jj

Let's capture CA certificate from admin't config:
```
kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 -d > ca.pem
```

Set cluster configusration:
```
# cluster name, server, cluster ca
kubectl config --kubeconfig=jj-kubeconfig \
  set-cluster $(kubectl config view -o jsonpath='{.clusters[0].name}') \
  --server=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}') \
  --certificate-authority=ca.pem \
  --embed-certs=true

# context, username
kubectl config --kubeconfig=jj-kubeconfig \
  set-context jj-developer \
  --user=jj \
  --cluster=$(kubectl config view -o jsonpath='{.clusters[0].name}')

kubectl config --kubeconfig=jj-kubeconfig \
  use-context jj-developer

# fetch jj's certificate and set it along with jj's key
kubectl get csr jj-developer -o jsonpath='{.status.certificate}' | base64 -d > jj.pem
kubectl --kubeconfig=jj-kubeconfig config \
  set-credentials jj \
  --client-certificate=jj.pem \
  --client-key=jj.key \
  --embed-certs=true
```

To verify user's certificate details just hit:
```
openssl x509 -text -noout -in jj.pem
```

## Set User's Permissions

### Allow Listing Nodes

```
kubectl create clusterrole node-viewer --resource=nodes --verb=list,get
kubectl create clusterrolebinding node-viewer --clusterrole=node-viewer --user=jj
kubectl --kubeconfig=jj-kubeconfig get nodes

# Using Client Config
kubectl --kubeconfig=jj-kubeconfig auth can-i list nodes
yes

# Using Admin Config
kubectl auth can-i list nodes --as=jj
yes
```

### Check Other Actions:
```
kubectl --kubeconfig=jj-kubeconfig get pods
Error from server (Forbidden): pods is forbidden: User "jj" cannot list resource "pods" in API group "" in the namespace "default"
```

### Cleanup - Removing User From the Cluster

```
kubectl delete clusterrolebindings.rbac.authorization.k8s.io node-viewer
kubectl delete rolebindings.rbac.authorization.k8s.io node-viewer
kubectl delete csr jj-developer
```