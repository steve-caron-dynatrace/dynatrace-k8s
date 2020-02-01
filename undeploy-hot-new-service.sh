#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "{YLW}Undeploying not so hot new service :-( ${NC}"

kubectl delete -f manifest/hot-new-service/

sleep 2s

kubectl get po