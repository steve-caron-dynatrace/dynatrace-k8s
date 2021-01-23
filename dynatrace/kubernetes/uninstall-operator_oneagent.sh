#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Uninstalling Dynatrace OneAgent and Operator...${NC}"
echo ""

kubectl delete -n dynatrace oneagent --all
kubectl delete -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml
kubectl delete ns dynatrace
kubectl get all -n dynatrace


