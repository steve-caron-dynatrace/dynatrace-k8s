#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying a brand hot new service!!!${NC}"

kubectl apply -f manifests/hot-new-service/


echo -e "${YLW}Waiting about 15 seconds for all pods to become ready...${NC}"
sleep 15s

kubectl get po
