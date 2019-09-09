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