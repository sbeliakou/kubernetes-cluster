#!/bin/bash

cat <<END
Executing ${0}
================================================================================

    Installing Metrics Server

    - https://github.com/kubernetes-incubator/metrics-server/blob/master/README.md
    - https://github.com/linuxacademy/metrics-server
    - https://raw.githubusercontent.com/kubernetes/kops/master/addons/metrics-server/v1.8.x.yaml

================================================================================

END

kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/metrics-server/v1.8.x.yaml

# Move to Master
kubectl -n kube-system patch deployment metrics-server -p '{
  "spec": {
    "template": {
      "spec": {
        "tolerations": [
          {
            "effect": "NoSchedule", 
            "key": "node-role.kubernetes.io/master"
          }
        ]
      }
    }
  }
}'