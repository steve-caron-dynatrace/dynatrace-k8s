#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying new Sock Shop carts build in dev...${NC}"

kubectl apply -f ../sockshop/manifests/scenarios/carts-new-build.yml

echo -e "${YLW}Waiting about 5 minutes for new build pods to become ready...${NC}"
sleep 330s
kubectl get po -l app=carts -n dev

