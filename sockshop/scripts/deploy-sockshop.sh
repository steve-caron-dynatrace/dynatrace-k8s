#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Sock Shop pods in sockshop-dev and sockshop-production...${NC}"

kubectl create -f ../manifests/k8s-namespaces.yml
#kubectl apply -f ../manifests/compute-resources-quota.yml

kubectl -n sockshop-production create rolebinding default-view --clusterrole=view --serviceaccount=sockshop-production:default
kubectl -n sockshop-dev create rolebinding default-view --clusterrole=view --serviceaccount=sockshop-dev:default

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

START=$(date +%s)
DIFF=0

# while not all public urls are available or more than 10 minutes have elapsed
while ( [ -z $PROD_FRONTEND_DOMAIN ] || [ -z $DEV_CARTS_DOMAIN ] ) && [ $DIFF -lt 600 ];
do
  if [ ! -z "$1" ] && [ "$1" == "-istio" ]
    then
      PROD_FRONTEND_DOMAIN=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
    else
      PROD_FRONTEND_DOMAIN=$(kubectl describe svc front-end -n sockshop-production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  fi
      DEV_CARTS_DOMAIN=$(kubectl describe svc carts -n sockshop-dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  echo -n .
  sleep 4
  NOW=$(date +%s)
  DIFF=$(( $NOW - $START ))
done

echo ""

if [ -z $PROD_FRONTEND_DOMAIN ];
then
  echo "SETUP ERROR : Sock Shop Frontend service could not get a public IP address"
  exit 1
else
  echo "Sock Shop Frontend Public Domain: $PROD_FRONTEND_DOMAIN"
fi

if [ -z $DEV_CARTS_DOMAIN ];
then
  echo "SETUP ERROR : Sock Shop Dev Carts service could not get a public IP address"
  exit 1
else
  echo "Sock Shop Dev Carts Public Domain: $DEV_CARTS_DOMAIN"
fi

echo -e "${YLW}Starting carts load test${NC}"
#start dev carts load 
nohup ./carts-load.sh &
