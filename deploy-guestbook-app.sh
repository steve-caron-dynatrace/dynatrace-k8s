#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Sock Shop pods in dev and production...${NC}"

kubectl create namespace guestbook

kubectl apply -f guestbook-app/

kubectl -n guestbook create rolebinding default-view --clusterrole=view --serviceaccount=guestbook:default

echo -e "${YLW}Waiting about 30 seconds for all pods to become ready...${NC}"
sleep 30s

kubectl get po --all-namespaces -l product=guestbook
