#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Istio Traffic Management for v1-v2...${NC}"

kubectl apply -f ../sockshop/manifests/scenarios/istio/destination_rule_carts.yml
kubectl apply -f ../sockshop/manifests/scenarios/istio/virtual_service_carts_v1_v2.yml
kubectl apply -f ../sockshop/manifests/scenarios/istio/virtual_service_v2_for_users.yml

