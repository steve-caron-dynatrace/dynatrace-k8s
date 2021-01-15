#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

kubectl scale --replicas=0 --current-replicas=1 deployments -l tier=frontend,product=sockshop -n sockshop-production

echo -e "{YLW}Scaling down production front-end deployments to 0 replica...${NC}"
kubectl get deployments -l tier=frontend,product=sockshop -n sockshop-production
sleep 10s
echo -e "{YLW}Scaling back up production front-end deployments...${NC}"

kubectl scale --replicas=1 --current-replicas=0 deployments -l tier=frontend,product=sockshop -n sockshop-production

echo -e "${YLW}Waiting about 10 seconds for pods to become ready...${NC}"
sleep 10s

kubectl get deployments -l tier=frontend,product=sockshop -n sockshop-production
