#!/bin/bash
  
YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying HipsterShop...${NC}"

../hipstershop/setup.sh

echo -e "${YLW}Waiting 2 minutes for the pods to become ready...${NC}"
sleep 120s

kubectl get po -n hipster-shop