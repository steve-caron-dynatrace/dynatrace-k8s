#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deleting SockShop...${NC}"

kubectl delete ns sockshop-dev
kubectl delete ns sockshop-production

