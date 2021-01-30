#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

kubectl delete po -l tier=frontend,product=sockshop -n sockshop-production

echo -e "{YLW}Deleting production front-end pods...${NC}"
kubectl get po -l tier=frontend,product=sockshop -n sockshop-production

echo -e "${YLW}Waiting about 20 seconds for pods to become ready...${NC}"
sleep 20s

kubectl get pod -l tier=frontend,product=sockshop -n sockshop-production
