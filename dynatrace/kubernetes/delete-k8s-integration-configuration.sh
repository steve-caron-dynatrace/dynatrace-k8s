#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deleting Dynatrace Kubernetes integration configuration...${NC}"

DT_API_URL=https://$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~').sprint.dynatracelabs.com/api
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

# getting k8s integration configs from dynatrace
echo -e "${YLW}Deleting k8s integrations...${NC}"

RESPONSE=$(curl -X GET -H "Content-Type: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" $DT_API_URL/config/v1/kubernetes/credentials)
echo $RESPONSE

# deleting k8s integration configs

for i in $(jq '.values | keys | .[]' <<< $RESPONSE); do
    if [[ $(jq -r ".values[$i] | .name" <<< $RESPONSE) = "dynatrace-workshop" ]]; then
        CONFIG_ID=$(jq -r ".values[$i] | .id" <<< $RESPONSE);
        echo $(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/config/v1/kubernetes/credentials/$CONFIG_ID");
    fi
done