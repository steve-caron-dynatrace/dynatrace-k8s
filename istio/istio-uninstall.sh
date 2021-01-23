#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YLW}Uninstalling Istio...${NC}"
echo ""

cd istio-1.7.4

export PATH=$PWD/bin:$PATH

kubectl delete -f samples/addons
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system


