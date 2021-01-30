#!/bin/bash
  
YLW='\033[1;33m'
NC='\033[0m'

kubectl delete po --all-namespaces -l product=sockshop

echo -e "${YLW}Deleting sockshop app pods...${NC}"
sleep 30s
kubectl get po --all-namespaces -l product=sockshop

echo -e "${YLW}Waiting about 5 minutes for all new pods to become ready...${NC}"
sleep 330s
kubectl get po --all-namespaces -l product=sockshop