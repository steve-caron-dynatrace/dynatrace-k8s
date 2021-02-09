#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deleting Dynatrace configurations for EasyTravel...${NC}"

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

# getting web applications from dynatrace
echo -e "${YLW}Deleting web applications...${NC}"

RESPONSE=$(curl -X GET -H "Content-Type: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" $DT_API_URL/api/config/v1/applications/web)
echo $RESPONSE

# deleting EasyTravel web application

for i in $(jq '.values | keys | .[]' <<< $RESPONSE); do
    if [[ $(jq -r ".values[$i] | .name" <<< $RESPONSE) = "EasyTravel" ]]; then
        APPLICATION_ID=$(jq -r ".values[$i] | .id" <<< $RESPONSE);
        echo $(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/applications/web/$APPLICATION_ID");
    fi
done

# getting synthetic monitors from dynatrace

RESPONSE=$(curl -X GET -H "Content-Type: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/v1/synthetic/monitors")
echo $RESPONSE

# deleting Sock Shop synthetic monitors

for i in $(jq '.monitors | keys | .[]' <<< $RESPONSE); do
    if [[ $(jq -r ".monitors[$i] | .name" <<< $RESPONSE) =~ "EasyTravel" ]]; then
        MONITOR_ID=$(jq -r ".monitors[$i] | .entityId" <<< $RESPONSE);
        echo $(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/v1/synthetic/monitors/$MONITOR_ID");
    fi
done