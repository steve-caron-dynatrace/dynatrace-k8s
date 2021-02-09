#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Configuring Dynatrace for EasyTravel...${NC}"

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')
EASYTRAVEL_WEBAPP_CONFIG=$(cat ./easytravel_webapp_template.json | sed "s/<EASYTRAVEL_WEBAPP_NAME>/EasyTravel/")

AUTOTAG_PRODUCT_CONFIG=$(cat ./tagging_rule_product.json)

#echo -e "${YLW}Creating auto-tagging rules...${NC}"

#RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$AUTOTAG_PRODUCT_CONFIG" $DT_API_URL/config/v1/autoTags) 
#echo $RESPONSE

echo -e "${YLW}Configuring EasyTravel Web Application...${NC}"

RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$EASYTRAVEL_WEBAPP_CONFIG" $DT_API_URL/api/config/v1/applications/web)

if [[ $RESPONSE == *"error"* ]]; then
    echo $RESPONSE
else
    APPLICATION_ID=$(echo $RESPONSE | grep -oP '(?<="id":")[^"]*')

        #create app detection rules

        EASYTRAVEL_URL=$(grep "EASYTRAVEL_URL=" ../../configuration.conf | sed 's~EASYTRAVEL_URL=[ \t]*~~')
        EASYTRAVEL_DOMAIN=$(kubectl describe svc easytravel-www -n easytravel | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
        APP_DETECTION_RULE=$(cat ./application_detection_rules_template.json | sed "s/<EASYTRAVEL_APP_ID>/$APPLICATION_ID/" | \
            sed "s/<EASYTRAVEL_DOMAIN>/$EASYTRAVEL_DOMAIN/")

        RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$APP_DETECTION_RULE" $DT_API_URL/api/config/v1/applicationDetectionRules)

        if [[ $RESPONSE == *"error"* ]]; then
            echo $RESPONSE
        else
            # add the internal service domain
            EASYTRAVEL_DOMAIN=easytravel-www
            APP_DETECTION_RULE=$(cat ./application_detection_rules_template.json | sed "s/<EASYTRAVEL_APP_ID>/$APPLICATION_ID/" | \
            sed "s/<EASYTRAVEL_DOMAIN>/$EASYTRAVEL_DOMAIN/")
            RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$APP_DETECTION_RULE" $DT_API_URL/api/config/v1/applicationDetectionRules)
        fi
fi

# create synthetic monitor

SYNTHETIC_CONFIG=$(cat ./easytravel_url_monitor-template.json | sed "s,<EASYTRAVEL_URL>,$EASYTRAVEL_URL," | sed "s,<APP_ID>,$APPLICATION_ID," )

RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SYNTHETIC_CONFIG" $DT_API_URL/api/v1/synthetic/monitors)

