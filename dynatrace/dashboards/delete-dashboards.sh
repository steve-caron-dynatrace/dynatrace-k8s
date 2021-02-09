#!/bin/bash
  
YLW='\033[1;33m'
NC='\033[0m'

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Deleting anomaly detection rules${NC}"

DASHBOARDS=$(curl -X GET "$DT_API_URL/api/config/v1/dashboards" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN")

DASHBOARD_ID=$(echo $DASHBOARDS | jq -c -r '.dashboards | .[] | select(.name == "Dynatrace workshop dashboard template") | .id')

if [ ! -z "$DASHBOARD_ID" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/dashboards/$DASHBOARD_ID");
    echo -e "${YLW}$RESPONSE${NC}"
fi
