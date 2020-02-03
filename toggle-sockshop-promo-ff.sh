#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Welcome to Sock Shop Exciting Promo feature flag setting${NC}"

read -p "Do you want to turn on (1) or off (2) the promo feature? Enter 1 or 2 : " -n 1 -r


if [[ $REPLY =~ ^[12]$ ]]
then
    if [[ $REPLY =~ ^1$ ]]
    then
            RATE=100
    else
            RATE=0
    fi
    PROD_CARTS_URL=http://$(kubectl describe svc carts -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//') 
    curl "$PROD_CARTS_URL/carts/1/items/promotion/$RATE"
else
echo ""
echo -e "${YLW}You did not enter a valid option (1 or 2). Nothing will be changed."
fi

