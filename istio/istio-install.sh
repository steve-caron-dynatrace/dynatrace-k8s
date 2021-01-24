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