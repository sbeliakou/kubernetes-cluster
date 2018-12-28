#!/bin/bash

bash /vagrant/vagrant/CentOS/scripts/helm.sh

cat <<END
Executing ${0}
================================================================================

    Deploying Prometheus

================================================================================

END

helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install coreos/kube-prometheus --name kube-prometheus --namespace monitoring

# kubectl -n monitoring apply -f /vagrant/configs/prometheus.yaml

# cd /opt/prometheus-operator/helm
# helm install helm/prometheus-operator --name prometheus-operator --namespace monitoring

# DOMAIN=$1

# cd /tmp/
# git clone https://github.com/kayrus/prometheus-kubernetes.git
# cd prometheus-kubernetes/

# # kubectl create namespace monitoring
# kubectl --namespace=monitoring create secret generic --from-literal=ca.pem=123 --from-literal=client.pem=123 --from-literal=client-key.pem=123 etcd-tls-client-certs

# mkdir -p /etc/prometheus/pki

# # Create Certificate
# if [ ! -f /etc/prometheus/pki/prometheus.${DOMAIN}_key.pem ]; then
#     openssl req -newkey rsa:2048 -nodes -x509 -days 3650 \
#         -subj "/C=BY/ST=Minsk/L=Minsk/O=Siarhei Beliakou Corp PLC/OU=IT/CN=*.${DOMAIN}" \
#         -keyout /etc/prometheus/pki/prometheus.${DOMAIN}_key.pem \
#         -out /etc/prometheus/pki/prometheus.${DOMAIN}_cert.pem \
#         -extensions v3_ca
# fi
# # Review Certificate
# openssl x509 -text -noout -in /etc/prometheus/pki/prometheus.${DOMAIN}_cert.pem

# kubectl create --namespace=monitoring secret tls prometheus-tls \
#     --cert=/etc/prometheus/pki/prometheus.${DOMAIN}_cert.pem \
#     --key=/etc/prometheus/pki/prometheus.${DOMAIN}_key.pem

# EXTERNAL_URL=https://prometheus.${DOMAIN} ./deploy.sh

# sed 's/prometheus.example.com/prometheus.'${DOMAIN}'/g;
#      s/grafana.example.com/grafana.'${DOMAIN}'/g;
#      s/example-tls/prometheus-tls/g' ./test_ingress/ingress-tls.yaml > ingress-tls.yaml

# kubectl -n monitoring apply -f ingress-tls.yaml