#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YLW}Downloading Istio...${NC}"
echo ""

## downloading istioctl
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.7.4 sh -

cd istio-1.7.4

## might not be necessary, seems it can work with classic ELB - need further testing
#cp ../values.yaml ./manifests/charts/gateways/istio-ingress/values.yaml

export PATH=$PWD/bin:$PATH

echo -e "${YLW}Installing Istio...${NC}"
echo ""

istioctl install --set profile=demo --manifests ./manifests

## Testing for ingress gateway public ip

SERVICE_NAME=istio-ingressgateway
NAMESPACE=istio-system

START=$(date +%s)
DIFF=0
# while public domain is not available or more than 10 minutes have elapsed
while [ -z $PUBLIC_DOMAIN ]  && [ $DIFF -lt 600 ];
do
  PUBLIC_DOMAIN=$(kubectl describe svc $SERVICE_NAME -n $NAMESPACE | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  echo -n .
  sleep 4
  NOW=$(date +%s)
  DIFF=$(( $NOW - $START ))
done

echo ""

if [ -z $PUBLIC_DOMAIN ];
then
  echo "SETUP ERROR : Istio ingress gateway could not get a public IP address"
else
  echo "Istio Ingress Gateway Domain: $PUBLIC_DOMAIN"
fi