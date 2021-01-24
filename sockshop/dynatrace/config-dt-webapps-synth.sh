#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Configuring Dynatrace for Sock Shop...${NC}"

DT_API_URL=https://$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~').sprint.dynatracelabs.com/api
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')
SOCKSHOP_WEBAPP_CONFIG=$(cat ./sockshop_webapp_template.json | sed "s/<SOCK_SHOP_WEBAPP_NAME>/Sock Shop - Production/")

AUTOTAG_PRODUCT_CONFIG=$(cat ./tagging_rule_product.json)
AUTOTAG_STAGE_CONFIG=$(cat ./tagging_rule_stage.json)

echo -e "${YLW}Creating auto-tagging rules...${NC}"

RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$AUTOTAG_PRODUCT_CONFIG" $DT_API_URL/config/v1/autoTags) 
echo $RESPONSE
RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$AUTOTAG_STAGE_CONFIG" $DT_API_URL/config/v1/autoTags)
echo $RESPONSE 

echo -e "${YLW}Configuring Sock Shop Web Application...${NC}"

RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SOCKSHOP_WEBAPP_CONFIG" $DT_API_URL/config/v1/applications/web) 

if [[ $RESPONSE == *"error"* ]]; then
    echo $RESPONSE
else
    PRODUCTION_APPLICATION_ID=$(echo $RESPONSE | grep -oP '(?<="id":")[^"]*')

        #create app detection rules

        PROD_FRONTEND_URL=$(grep "SOCKSHOP_PROD_FRONTEND_URL=" ../../configuration.conf | sed 's~SOCKSHOP_PROD_FRONTEND_URL=[ \t]*~~')

        if [ ! -z "$1" ] && [ "$1" == "-istio" ]
          then
            PROD_FRONTEND_DOMAIN=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
          else
            PROD_FRONTEND_DOMAIN=$(kubectl describe svc front-end -n sockshop-production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
        fi
        #production
        APP_DETECTION_RULE=$(cat ./application_detection_rules_template.json | sed "s/<SOCKSHOP_APP_ID>/$PRODUCTION_APPLICATION_ID/" | \
            sed "s/<SOCKSHOP_FRONTEND_DOMAIN>/$PROD_FRONTEND_DOMAIN/")

        RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$APP_DETECTION_RULE" $DT_API_URL/config/v1/applicationDetectionRules)

        if [[ $RESPONSE == *"error"* ]]; then
            echo $RESPONSE
        else
            echo -e "${YLW}Creating Sock Shop Synthetic Monitors...${NC}"
            #create synthetic tests (4 with users, 4 anonymous)

            USERNAME_PRE=$(grep "SOCKSHOP_USERNAME_PRE=" ../../configuration.conf | sed 's~SOCKSHOP_USERNAME_PRE=[ \t]*~~')

            SYNTHETIC_CONFIG=$(cat ./sockshop_synthetic_template.json | sed "s,<SOCKSHOP_FRONTEND_URL>,$PROD_FRONTEND_URL," | sed "s/<SOCKSHOP_WEB_APP_ID>/$PRODUCTION_APPLICATION_ID/" )
            SYNTHETIC_CONFIG_ANONYMOUS=$(cat ./sockshop_synthetic_template_anonymous.json | sed "s,<SOCKSHOP_FRONTEND_URL>,$PROD_FRONTEND_URL," | sed "s/<SOCKSHOP_WEB_APP_ID>/$PRODUCTION_APPLICATION_ID/" )
            for i in {1..4}
            do
                sleep 30s
		        SYNTHETIC_CONFIG_NEW=$(echo $SYNTHETIC_CONFIG | sed "s/<SOCKSHOP_TEST_NAME>/Sock Shop - $i/" | sed "s/<SOCKSHOP_USERNAME>/$USERNAME_PRE$i/")
                RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SYNTHETIC_CONFIG_NEW" $DT_API_URL/v1/synthetic/monitors)
                sleep 30s
                SYNTHETIC_CONFIG_ANONYMOUS_NEW=$(echo $SYNTHETIC_CONFIG_ANONYMOUS | sed "s/<SOCKSHOP_TEST_NAME>/Sock Shop Anonymous - $i/")
                RESPONSE2=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SYNTHETIC_CONFIG_ANONYMOUS_NEW" $DT_API_URL/v1/synthetic/monitors)

            done

            if [[ $RESPONSE == *"error"* ]]; then
                echo $RESPONSE
            fi
            if [[ $RESPONSE2 == *"error"* ]]; then
                echo $RESPONSE2
            fi
        fi
fi


