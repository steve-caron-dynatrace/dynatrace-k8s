#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'


DT_API_URL=https://$(grep "DT_ENVIRONMENT_ID=" configs.txt | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~').sprint.dynatracelabs.com/api
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" configs.txt | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')
SOCKSHOP_WEBAPP_CONFIG=$(cat ./dynatrace-config/sockshop_webapp_template.json | sed "s/<SOCK_SHOP_WEBAPP_NAME>/Sock Shop - Production/")

AUTOTAG_PRODUCT_CONFIG=$(cat ./dynatrace-config/tagging_rule_product.json)
AUTOTAG_STAGE_CONFIG=$(cat ./dynatrace-config/tagging_rule_stage.json)

RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$AUTOTAG_PRODUCT_CONFIG" $DT_API_URL/config/v1/autotags) 
echo $RESPONSE
RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$AUTOTAG_STAGE_CONFIG" $DT_API_URL/config/v1/autotags)
echo $RESPONSE 