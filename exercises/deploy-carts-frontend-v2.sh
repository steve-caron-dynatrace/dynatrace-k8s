#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Sock Shop carts-v2 and frontend-v2 in production...${NC}"

kubectl apply -f ../sockshop/manifests/scenarios/carts-v2.yml
kubectl apply -f ../sockshop/manifests/scenarios/front-end-v2.yml

echo -e "${YLW}Waiting about 5 minutes for the new carts pod to become ready...${NC}"
sleep 330s
kubectl get po -l app=carts -l app=front-end -l version=v2 -n sockshop-production