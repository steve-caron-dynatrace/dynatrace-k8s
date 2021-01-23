#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

START=$(date +%s)
DIFF=0
# while not all public urls are available or more than 6 minutes have elapsed
while ( [ -z $PROD_FRONTEND_URL ] || [ -z $PROD_CARTS_URL ] || [ -z $DEV_CARTS_URL ] ) && [ $DIFF -lt 360 ];
do
  if [ ! -z "$1" ] && [ "$1" == "-istio" ]
    then
      PROD_FRONTEND_URL=http://$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
      PROD_CARTS_URL=$PROD_FRONTEND_URL
    else
      PROD_FRONTEND_URL=http://$(kubectl describe svc front-end -n sockshop-production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//'):8080
      PROD_CARTS_URL=http://$(kubectl describe svc carts -n sockshop-production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  fi
      DEV_CARTS_URL=http://$(kubectl describe svc carts -n sockshop-dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  echo -n .
  sleep 4
  NOW=$(date +%s)
  DIFF=$(( $NOW - $START ))
done

sed -i -r 's~SOCKSHOP_PROD_FRONTEND_URL=(.*)~SOCKSHOP_PROD_FRONTEND_URL\='"$PROD_FRONTEND_URL"'~' ../../configuration.conf
sed -i -r 's~SOCKSHOP_PROD_CARTS_URL=(.*)~SOCKSHOP_PROD_CARTS_URL\='"$PROD_CARTS_URL"'~' ../../configuration.conf
sed -i -r 's~SOCKSHOP_DEV_CARTS_URL=(.*)~SOCKSHOP_DEV_CARTS_URL\='"$DEV_CARTS_URL"'~' ../../configuration.conf

echo ""
echo -e "${YLW}Your application URLs:${NC}"
echo ""
echo -e "${YLW}Sock Shop Production frontend:${NC} $PROD_FRONTEND_URL"
echo -e "${YLW}Sock Shop Production carts:${NC} $PROD_CARTS_URL"
echo -e "${YLW}Sock Shop Dev carts:${NC} $DEV_CARTS_URL" 
echo ""
echo -e "${YLW}You can also get those any time with this command :${NC} cat ../../configuration.conf" 