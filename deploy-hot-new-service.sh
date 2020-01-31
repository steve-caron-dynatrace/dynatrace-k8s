#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "{YLW}Deploying a brand hot new service!!!${NC}"

kubectl apply -f manifest/hot-new-service/


echo -e "${YLW}Waiting about 10 seconds for all pods to become ready...${NC}"
sleep 10s

kubectl get po