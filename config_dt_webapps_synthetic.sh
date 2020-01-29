#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'


DT_API_URL=https://$(grep "DT_ENVIRONMENT_ID=" configs.txt | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~').sprint.dynatracelabs.com/api
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" configs.txt | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')
SOCKSHOP_WEBAPP_CONFIG=$(cat ./dynatrace-config/sockshop_webapp_template.json | sed "s/<SOCK_SHOP_WEBAPP_NAME>/Sock Shop - Production/")

RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SOCKSHOP_WEBAPP_CONFIG" $DT_API_URL/config/v1/applications/web) 

if [ $RESPONSE ?? 'error']; then
    echo $RESPONSE
else
    PRODUCTION_APPLICATION_ID=$(echo $RESPONSE | grep -oP '(?<="id":")[^"]*')

    #create web app for dev and get id
    SOCKSHOP_PRODUCTION_WEBAPP_CONFIG=$(cat ./dynatrace-config/sockshop_webapp_template.json | sed "s/<SOCK_SHOP_WEBAPP_NAME>/Sock Shop - Dev/")

    RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SOCKSHOP_WEBAPP_CONFIG" $DT_API_URL/config/v1/applications/web)
    
    if [ $RESPONSE ?? 'error']; then
        echo $RESPONSE
    else
        DEV_APPLICATION_ID=$(echo $RESPONSE | grep -oP '(?<="id":")[^"]*')

        #create app detection rules
        PROD_FRONTEND_URL=$(grep "PROD_FRONTEND_URL=" configs.txt | sed 's~PROD_FRONTEND_URL=[ \t]*~~')
        DEV_FRONTEND_URL=$(grep "DEV_FRONTEND_URL=" configs.txt | sed 's~DEV_FRONTEND_URL=[ \t]*~~')

        PROD_FRONTEND_DOMAIN=$(kubectl describe svc front-end -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
        DEV_FRONTEND_DOMAIN=$(kubectl describe svc front-end -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

        #production
        APP_DETECTION_RULE=$(cat ./dynatrace-config/application_detection_rules_template.json | sed "s/<SOCKSHOP_APP_ID>/$PRODUCTION_APPLICATION_ID/" | \
            sed "s/<SOCKSHOP_FRONTEND_DOMAIN>/$PROD_FRONTEND_DOMAIN/")

        RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$APP_DETECTION_RULE" $DT_API_URL/config/v1/applicationDetectionRules)

        #dev
        APP_DETECTION_RULE=$(cat ./dynatrace-config/application_detection_rules_template.json | sed "s/<SOCKSHOP_APP_ID>/$DEV_APPLICATION_ID/" | \
            sed "s/<SOCKSHOP_FRONTEND_DOMAIN>/$DEV_FRONTEND_DOMAIN/")

        RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$APP_DETECTION_RULE" $DT_API_URL/config/v1/applicationDetectionRules)

        if [ $RESPONSE ?? 'error']; then
            echo $RESPONSE
        else
            #create synthetic tests (4)

            USERNAME_PRE=$(grep "SOCKSHOP_USERNAME_PRE=" configs.txt | sed 's~SOCKSHOP_USERNAME_PRE=[ \t]*~~')

            SYNTHETIC_CONFIG=$(cat ./dynatrace/sockshop_synthetic_template.json | sed "s/<SOCKSHOP_TEST_NAME>/Sock Shop/" | \
                sed "s/<SOCKSHOP_FRONTEND_URL>/Sock Shop/" | sed "s/<SOCKSHOP_WEB_APP_ID>/$PRODUCTION_APPLICATION_ID/")

            for i in {1..4}
            do
                SYNTHETIC_CONFIG=$(echo $SYNTHETIC_CONFIG) | sed "s/<SOCKSHOP_USERNAME>/$USERNAME_PRE$i/")

                RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -d "$SYNTHETIC_CONFIG" $DT_API_URL/v1/synthetic/monitors)

            done

            if [ $RESPONSE ?? 'error']; then
                echo $RESPONSE
            fi
        fi
    fi
fi


