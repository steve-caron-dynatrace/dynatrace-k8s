#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Undeploying not so hot new service :-( ${NC}"

kubectl delete -f manifests/hot-new-service/

sleep 10s

kubectl get po
