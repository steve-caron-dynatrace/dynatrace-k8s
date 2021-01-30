#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Deleting anomaly detection rules${NC}"

ANOMALY_DETECTION_RULES=$(curl  -X GET "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents?includeEntityFilterMetricEvents=false" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN")

OOM_KILL_ID=$(echo $ANOMALY_DETECTION_RULES | jq -c -r '.values | .[] | select(.name == "Container OOMKills") | .id')
PENDING_POD_ID=$(echo $ANOMALY_DETECTION_RULES | jq -c -r '.values | .[] | select(.name == "Pending pods") | .id')
CPU_THROTTLE_ID=$(echo $ANOMALY_DETECTION_RULES | jq -c -r '.values | .[] | select(.name == "Container CPU throttle") | .id')


if [ ! -z "$OOM_KILL_ID" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents/$OOM_KILL_ID");
    echo -e "${YLW}$RESPONSE${NC}"
fi
if [ ! -z "$PENDING_POD_ID" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents/$PENDING_POD_ID");
    echo -e "${YLW}$RESPONSE${NC}"
fi
if [ ! -z "$CPU_THROTTLE_ID" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents/$CPU_THROTTLE_ID");
    echo -e "${YLW}$RESPONSE${NC}"
fi
