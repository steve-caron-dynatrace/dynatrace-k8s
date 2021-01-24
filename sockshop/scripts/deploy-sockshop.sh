#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Sock Shop pods in sockshop-dev and sockshop-production...${NC}"

kubectl create -f ../manifests/k8s-namespaces.yml
#kubectl apply -f ../manifests/compute-resources-quota.yml

kubectl apply -f ../manifests/backend-services/user-db/sockshop-dev/
kubectl apply -f ../manifests/backend-services/user-db/sockshop-production/

kubectl apply -f ../manifests/backend-services/shipping-rabbitmq/sockshop-dev/
kubectl apply -f ../manifests/backend-services/shipping-rabbitmq/sockshop-production/

kubectl apply -f ../manifests/backend-services/carts-db/

kubectl apply -f ../manifests/backend-services/catalogue-db/

kubectl apply -f ../manifests/backend-services/orders-db/

kubectl apply -f ../manifests/sockshop-app/sockshop-dev/
kubectl apply -f ../manifests/sockshop-app/sockshop-production/

if [ ! -z "$1" ] && [ "$1" == "-istio" ]
  then
    kubectl apply -f ../manifests/scenarios/istio/gateway.yml
    kubectl apply -f ../manifests/scenarios/istio/virtual_service_with_carts.yml
    kubectl apply -f ../manifests/scenarios/istio/destination_rule.yml
fi

echo -e "${YLW}Waiting about 5 minutes for all pods to become ready...${NC}"
sleep 330s
kubectl get po --all-namespaces -l product=sockshop

echo -e "${YLW}Starting carts load test${NC}"
#start dev carts load 
nohup ./carts-load.sh &
