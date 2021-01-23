#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deleting Dynatrace configurations for Sock Shop...${NC}"

DT_API_URL=https://$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~').sprint.dynatracelabs.com/api
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

# getting auto-tagging rules from dynatrace
echo -e "${YLW}Deleting auto-tagging rules...${NC}"

RESPONSE=$(curl -X GET -H "Content-Type: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" $DT_API_URL/config/v1/autoTags)
echo $RESPONSE

# deleting auto-tagging rules

for i in $(jq '.values | keys | .[]' <<< $RESPONSE); do
    TAG_RULE_ID=$(jq -r ".values[$i] | .id" <<< $RESPONSE);
    echo $(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/config/v1/autoTags/$TAG_RULE_ID");
done

# getting web applications from dynatrace
echo -e "${YLW}Deleting web applications...${NC}"

RESPONSE=$(curl -X GET -H "Content-Type: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" $DT_API_URL/config/v1/applications/web)
echo $RESPONSE

# deleting SockShop - Production web application

for i in $(jq '.values | keys | .[]' <<< $RESPONSE); do
    if [[ $(jq -r ".values[$i] | .name" <<< $RESPONSE) = "Sock Shop - Production" ]]; then
            APPLICATION_ID=$(jq -r ".values[$i] | .id" <<< $RESPONSE);
            echo $(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/config/v1/applications/web/$APPLICATION_ID");
    fi
done

echo -e "${YLW}Deleting synthetic monitors...${NC}"
# getting synthetic monitors from dynatrace

RESPONSE=$(curl -X GET -H "Content-Type: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/v1/synthetic/monitors")
echo $RESPONSE

# deleting Sock Shop synthetic monitors

for i in $(jq '.monitors | keys | .[]' <<< $RESPONSE); do
    if [[ $(jq -r ".monitors[$i] | .name" <<< $RESPONSE) =~ "Sock Shop" ]]; then
        MONITOR_ID=$(jq -r ".monitors[$i] | .entityId" <<< $RESPONSE);
        echo $(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/v1/synthetic/monitors/$MONITOR_ID");
    fi
done