#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Dynatrace OneAgent Operator...${NC}"
echo ""

kubectl create namespace dynatrace
kubectl apply -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml
DT_API_TOKEN=$(grep "DT_API_TOKEN=" ../../configuration.conf | sed 's~DT_API_TOKEN=[ \t]*~~')
DT_PAAS_TOKEN=$(grep "DT_PAAS_TOKEN=" ../../configuration.conf | sed 's~DT_PAAS_TOKEN=[ \t]*~~')
kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken="$DT_API_TOKEN --from-literal="paasToken="$DT_PAAS_TOKEN
./config-cr.sh -$1
kubectl apply -f cr.yaml
sleep 70
kubectl get po -n dynatrace


