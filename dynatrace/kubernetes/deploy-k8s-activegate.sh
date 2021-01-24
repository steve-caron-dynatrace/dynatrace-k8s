#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Dynatrace Kubernetes ActiveGate...${NC}"
echo ""

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_PAAS_TOKEN=$(grep "DT_PAAS_TOKEN=" ../../configuration.conf | sed 's~DT_PAAS_TOKEN=[ \t]*~~')

kubectl create secret docker-registry dynatrace-docker-registry --docker-server=$TENANT_ID.sprint.dynatracelabs.com --docker-username=$TENANT_ID --docker-password=$DT_PAAS_TOKEN -n dynatrace

cp k8s-ag-template.yaml k8s-ag.yaml

sed -i "s/<YOUR_ENVIRONMENT_URL>/$TENANT_ID.sprint.dynatracelabs.com/" k8s-ag.yaml
sed -i "s/<ANY_UNIQUE_ID>/dynatrace-workshop/" k8s-ag.yaml

kubectl apply -f k8s-ag.yaml

echo -e "${YLW}Waiting 2 minutes for Dynatrace Kubernetes ActiveGate to deploy...${NC}"
sleep 120
