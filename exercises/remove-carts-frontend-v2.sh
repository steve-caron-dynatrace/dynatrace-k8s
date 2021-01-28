#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Removing Sock Shop carts-v2 and frontend-v2 in production...${NC}"

kubectl delete -f ../sockshop/manifests/scenarios/carts-v2.yml
kubectl delete -f ../sockshop/manifests/scenarios/front-end-v2.yml

sleep 30s
kubectl get po -l app=carts -l app=front-end -l version=v2 -n sockshop-production