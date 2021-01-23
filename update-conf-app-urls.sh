#!/bin/bash
  
YLW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

cd $CURRENT_DIR/easytravel/scripts
./get-easytravel-urls.sh > /dev/null 2>&1

## Deploy Sock Shop app
cd $CURRENT_DIR/sockshop/scripts
./get-sockshop-urls.sh -istio > /dev/null 2>&1

EASYTRAVEL_WWW_URL=$(grep "EASYTRAVEL_URL=" ../../configuration.conf | sed 's~EASYTRAVEL_URL=[ \t]*~~')
SOCKSHOP_FRONTEND_URL=$(grep "SOCKSHOP_PROD_FRONTEND_URL=" ../../configuration.conf | sed 's~SOCKSHOP_PROD_FRONTEND_URL=[ \t]*~~')
SOCKSHOP_CARTS_PROD_URL=$(grep "SOCKSHOP_PROD_CARTS_URL=" ../../configuration.conf | sed 's~SOCKSHOP_PROD_CARTS_URL=[ \t]*~~')
SOCKSHOP_CARTS_DEV_URL=$(grep "SOCKSHOP_DEV_CARTS_URL=" ../../configuration.conf | sed 's~SOCKSHOP_DEV_CARTS_URL=[ \t]*~~')

echo ""
echo -e "${YLW}APPLICATION URLS${NC}"
echo ""
echo -e "${YLW}EasyTravel URL: ${NC}$EASYTRAVEL_WWW_URL"
echo -e "${YLW}SockShop Front-end Production URL: ${NC}$SOCKSHOP_FRONTEND_URL"
echo -e "${YLW}SockShop Carts Service Production URL: ${NC}$SOCKSHOP_CARTS_PROD_URL"
echo -e "${YLW}SockShop Carts Service Dev URL: ${NC}$SOCKSHOP_CARTS_DEV_URL"
echo ""

