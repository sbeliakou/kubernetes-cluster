#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    Installing Metrics Server

    - https://github.com/kubernetes-incubator/metrics-server/blob/master/README.md
    - https://github.com/linuxacademy/metrics-server

================================================================================

END

yum install -y git

cd /tmp/
git clone https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server

kubectl create -f deploy/1.8+/
# ps -eo args | grep -v grep | grep apiserver | sed 's/--/\n  --/g'
# ... --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname ...
kubectl patch deployment/metrics-server -n kube-system --patch '{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "metrics-server", 
            "command":[
              "/metrics-server", 
              "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
              "--kubelet-insecure-tls"
            ]
          }
        ]
      }
    }
  }
}'

rm -rf metrics-server