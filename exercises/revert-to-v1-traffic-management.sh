#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Reverting to traffic management for v1 only...${NC}"

kubectl apply -f ../sockshop/manifests/scenarios/istio/virtual_service_carts_v1_only.yml
kubectl apply -f ../sockshop/manifests/scenarios/istio/virtual_service_with_carts.yml

