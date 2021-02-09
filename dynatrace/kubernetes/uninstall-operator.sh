#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Uninstalling Dynatrace Operator...${NC}"
echo ""

./delete-k8s-integration-configuration.sh

kubectl delete -n dynatrace dynakube --all
kubectl delete -f https://github.com/Dynatrace/dynatrace-operator/releases/latest/download/kubernetes.yaml
kubectl delete ns dynatrace
kubectl get all -n dynatrace


