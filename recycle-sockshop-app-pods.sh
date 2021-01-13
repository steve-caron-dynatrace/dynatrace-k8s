#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

kubectl scale --replicas=0 deployment/carts -n sockshop-dev
kubectl scale --replicas=0 deployment/carts -n sockshop-production

kubectl scale --replicas=0 deployment/catalogue -n sockshop-dev
kubectl scale --replicas=0 deployment/catalogue -n sockshop-production

kubectl scale --replicas=0 deployment/front-end -n sockshop-dev
kubectl scale --replicas=0 deployment/front-end -n sockshop-production

kubectl scale --replicas=0 deployment/orders -n sockshop-dev
kubectl scale --replicas=0 deployment/orders -n sockshop-production

kubectl scale --replicas=0 deployment/payment -n sockshop-dev
kubectl scale --replicas=0 deployment/payment -n sockshop-production

kubectl scale --replicas=0 deployment/queue-master -n sockshop-dev
kubectl scale --replicas=0 deployment/queue-master -n sockshop-production

kubectl scale --replicas=0 deployment/rabbitmq -n sockshop-dev
kubectl scale --replicas=0 deployment/rabbitmq -n sockshop-production

kubectl scale --replicas=0 deployment/shipping -n sockshop-dev
kubectl scale --replicas=0 deployment/shipping -n sockshop-production

kubectl scale --replicas=0 deployment/user -n sockshop-dev
kubectl scale --replicas=0 deployment/user -n sockshop-production

echo -e "${YLW}Scaling down deployments to 0 replica...${NC}"
sleep 30s
kubectl get deployment --all-namespaces -l product=sockshop
echo -e "${YLW}Scaling back up deployments...${NC}"

kubectl scale --replicas=1 deployment/carts -n sockshop-dev
kubectl scale --replicas=1 deployment/carts -n sockshop-production

kubectl scale --replicas=1 deployment/catalogue -n sockshop-dev
kubectl scale --replicas=1 deployment/catalogue -n sockshop-production

kubectl scale --replicas=1 deployment/front-end -n sockshop-dev
kubectl scale --replicas=1 deployment/front-end -n sockshop-production

kubectl scale --replicas=1 deployment/orders -n sockshop-dev
kubectl scale --replicas=1 deployment/orders -n sockshop-production

kubectl scale --replicas=1 deployment/payment -n sockshop-dev
kubectl scale --replicas=1 deployment/payment -n sockshop-production

kubectl scale --replicas=1 deployment/queue-master -n sockshop-dev
kubectl scale --replicas=1 deployment/queue-master -n sockshop-production

kubectl scale --replicas=1 deployment/rabbitmq -n sockshop-dev
kubectl scale --replicas=1 deployment/rabbitmq -n sockshop-production

kubectl scale --replicas=1 deployment/shipping -n sockshop-dev
kubectl scale --replicas=1 deployment/shipping -n sockshop-production

kubectl scale --replicas=1 deployment/user -n sockshop-dev
kubectl scale --replicas=1 deployment/user -n sockshop-production

echo -e "${YLW}Waiting about 5 minutes for all pods to become ready...${NC}"
sleep 330s
kubectl get deployment --all-namespaces -l product=sockshop
