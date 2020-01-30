#!/bin/bash

YLW='\033[1;33m' 
NC='\033[0m'

START=$(date +%s)
DIFF=0
# while not all public urls are available or more than 6 minutes have elapsed
while ( [ -z $PROD_FRONTEND_URL ] || [ -z $PROD_CARTS_URL ] || [ -z $DEV_FRONTEND_URL ] || [ -z $DEV_CARTS_URL ] ) && [ $DIFF -lt 360 ];
do
  PROD_FRONTEND_URL=http://$(kubectl describe svc front-end -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//'):8080
  PROD_CARTS_URL=http://$(kubectl describe svc carts -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  DEV_FRONTEND_URL=http://$(kubectl describe svc front-end -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//'):8080
  DEV_CARTS_URL=http://$(kubectl describe svc carts -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  echo -n .
  sleep 4
  NOW=$(date +%s)
  DIFF=$(( $NOW - $START ))
done

sed -i -r 's~PROD_FRONTEND_URL=(.*)~PROD_FRONTEND_URL\='"$PROD_FRONTEND_URL"'~' ./configs.txt
sed -i -r 's~PROD_CARTS_URL=(.*)~PROD_CARTS_URL\='"$PROD_CARTS_URL"'~' ./configs.txt  
sed -i -r 's~DEV_FRONTEND_URL=(.*)~DEV_FRONTEND_URL\='"$DEV_FRONTEND_URL"'~' ./configs.txt
sed -i -r 's~DEV_CARTS_URL=(.*)~DEV_CARTS_URL\='"$DEV_CARTS_URL"'~' ./configs.txt         

echo ""
echo -e "${YLW}Your application URLs:${NC}"
echo ""
echo -e "${YLW}Sock Shop Production frontend:${NC} $PROD_FRONTEND_URL"
echo -e "${YLW}Sock Shop Production carts:${NC} $PROD_CARTS_URL"
echo -e "${YLW}Sock Shop Dev frontend:${NC} $DEV_FRONTEND_URL" 
echo -e "${YLW}Sock Shop Dev carts:${NC} $DEV_CARTS_URL" 
echo ""
echo -e "${YLW}You can also get those anytime with this command :${NC} cat configs.txt" 

