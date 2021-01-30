#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

EASYTRAVEL_URL=$(grep "EASYTRAVEL_URL=" ../../configuration.conf | sed 's~EASYTRAVEL_URL=[ \t]*~~')
PROD_FRONTEND_URL=$(grep "SOCKSHOP_PROD_FRONTEND_URL=" ../../configuration.conf | sed 's~SOCKSHOP_PROD_FRONTEND_URL=[ \t]*~~')
DEV_CARTS_URL=$(grep "SOCKSHOP_DEV_CARTS_URL=" ../../configuration.conf | sed 's~SOCKSHOP_DEV_CARTS_URL=[ \t]*~~')
API_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

DASHBOARD=$(cat ./your_very_own_dashboard.json | sed "s,<EASYTRAVEL_URL>,$EASYTRAVEL_URL," | \
            sed "s,<SOCKSHOP_PROD_FRONTEND_URL>,$PROD_FRONTEND_URL," | sed "s,<SOCKSHOP_DEV_CARTS_URL>,$DEV_CARTS_URL," | sed "s/<API_TOKEN>/$API_TOKEN/")

echo -e "${YLW}Creating custom dashboard${NC}"

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/dashboards" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$DASHBOARD")
echo -e "${YLW}$RESPONSE${NC}"
