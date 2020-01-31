#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "{YLW}Deploying a brand hot new service!!!${NC}"

kubectl apply -f manifest/

kubectl -n guestbook create rolebinding default-view --clusterrole=view --serviceaccount=guestbook:default

echo -e "${YLW}Waiting about 30 seconds for all pods to become ready...${NC}"
sleep 30s

kubectl get po --all-namespaces -l product=guestbook