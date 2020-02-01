#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Sock Shop pods in dev and production...${NC}"

kubectl create -f manifests/k8s-namespaces.yml

kubectl apply -f manifests/backend-services/user-db/dev/
kubectl apply -f manifests/backend-services/user-db/production/

kubectl apply -f manifests/backend-services/shipping-rabbitmq/dev/
kubectl apply -f manifests/backend-services/shipping-rabbitmq/production/

kubectl apply -f manifests/backend-services/carts-db/

kubectl apply -f manifests/backend-services/catalogue-db/

kubectl apply -f manifests/backend-services/orders-db/

kubectl apply -f manifests/sockshop-app/dev/
kubectl apply -f manifests/sockshop-app/production/

echo -e "${YLW}Waiting about 5 minutes for all pods to become ready...${NC}"
sleep 330s
kubectl get po --all-namespaces -l product=sockshop

echo -e "${YLW}Starting carts load test${NC}"
#start dev carts load 
nohup ./carts-load.sh &
