#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

kubectl scale --replicas=0 deployment/carts -n dev
kubectl scale --replicas=0 deployment/carts -n production

kubectl scale --replicas=0 deployment/catalogue -n dev
kubectl scale --replicas=0 deployment/catalogue -n production

kubectl scale --replicas=0 deployment/front-end -n dev
kubectl scale --replicas=0 deployment/front-end -n production

kubectl scale --replicas=0 deployment/orders -n dev
kubectl scale --replicas=0 deployment/orders -n production

kubectl scale --replicas=0 deployment/payment -n dev
kubectl scale --replicas=0 deployment/payment -n production

kubectl scale --replicas=0 deployment/queue-master -n dev
kubectl scale --replicas=0 deployment/queue-master -n production

kubectl scale --replicas=0 deployment/rabbitmq -n dev
kubectl scale --replicas=0 deployment/rabbitmq -n production

kubectl scale --replicas=0 deployment/shipping -n dev
kubectl scale --replicas=0 deployment/shipping -n production

kubectl scale --replicas=0 deployment/user -n dev
kubectl scale --replicas=0 deployment/user -n production

echo -e "{YLW}Scaling down deployments to 0 replica...${NC}"
kubectl get deployment --all-namespaces -l product=sockshop
sleep 30s
echo -e "{YLW}Scaling back up deployments...${NC}"

kubectl scale --replicas=1 deployment/carts -n dev
kubectl scale --replicas=1 deployment/carts -n production

kubectl scale --replicas=1 deployment/catalogue -n dev
kubectl scale --replicas=1 deployment/catalogue -n production

kubectl scale --replicas=1 deployment/front-end -n dev
kubectl scale --replicas=1 deployment/front-end -n production

kubectl scale --replicas=1 deployment/orders -n dev
kubectl scale --replicas=1 deployment/orders -n production

kubectl scale --replicas=1 deployment/payment -n dev
kubectl scale --replicas=1 deployment/payment -n production

kubectl scale --replicas=1 deployment/queue-master -n dev
kubectl scale --replicas=1 deployment/queue-master -n production

kubectl scale --replicas=1 deployment/rabbitmq -n dev
kubectl scale --replicas=1 deployment/rabbitmq -n production

kubectl scale --replicas=1 deployment/shipping -n dev
kubectl scale --replicas=1 deployment/shipping -n production

kubectl scale --replicas=1 deployment/user -n dev
kubectl scale --replicas=1 deployment/user -n production

echo -e "${YLW}Waiting about 5 minutes for all pods to become ready...${NC}"
sleep 330s
kubectl get deployment --all-namespaces -l product=sockshop
