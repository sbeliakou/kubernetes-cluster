#!/bin/bash

IPADDR=$1
TOKEN=$2

kubeadm join --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification ${IPADDR}:6443