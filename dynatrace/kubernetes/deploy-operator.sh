#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Dynatrace Operator...${NC}"
echo ""

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')/api
DT_API_TOKEN=$(grep "DT_API_TOKEN=" ../../configuration.conf | sed 's~DT_API_TOKEN=[ \t]*~~')
DT_PAAS_TOKEN=$(grep "DT_PAAS_TOKEN=" ../../configuration.conf | sed 's~DT_PAAS_TOKEN=[ \t]*~~')

./install.sh --api-url ${DT_API_URL} --api-token ${DT_API_TOKEN} --paas-token ${DT_PAAS_TOKEN} \
    --set-app-log-content-access --skip-ssl-verification --enable-k8s-monitoring \
    --connection-name "dynatrace-workshop" --enable-events --enable-istio \
    --enable-prometheus-exporter-integration

echo -e "${YLW}Waiting 2 minutes for pods to become ready...${NC}"
sleep 120
kubectl get po -n dynatrace



