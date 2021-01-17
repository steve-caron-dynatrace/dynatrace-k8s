#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

kubectl apply -f https://www.dynatrace.com/support/help/codefiles/kubernetes/kubernetes-monitoring-service-account.yaml

echo -e "${YLW}Obtaining k8s master API URL and bearer token${NC}"
export K8S_API_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
export BEARER_TOKEN=$(kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode)
export CLUSTER_NAME="dynatrace-workshop"
export CONNECTION_CONFIG="{ \"label\": \"$CLUSTER_NAME\", \"endpointUrl\": \"$K8S_API_URL\", \"authToken\": \"$BEARER_TOKEN\", \"active\": true, \"certificateCheckEnabled\": false, \"prometheusExportersIntegrationEnabled\": true, \"eventsIntegrationEnabled\": true, \"eventsFieldSelectors\": [{\"label\": \"Node events\", \"fieldSelector\": \"involvedObject.kind=Node\", \"active\": true}, {\"label\": \"Non-node events\", \"fieldSelector\": \"involvedObject.kind!=Node\", \"active\": true}]}"


ENDPOINTS=$(curl -s "$DT_API_URL/api/config/v1/kubernetes/credentials" -H "accept: application/json" -H "Authorization: Api-Token $DT_CONFIG_TOKEN")

for row in $(echo "${ENDPOINTS}" | jq '.values' | jq -c '.[]'); do

    if [ $(echo $row | jq -c -r ".name") = $CLUSTER_NAME ]
    then
        echo "Cluster already exists... updating configuration"
        ENDPOINT_ID=$(echo $row | jq -c -r ".id")
        curl -X DELETE "$DT_API_URL/api/config/v1/kubernetes/credentials/$ENDPOINT_ID" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type:application/json; charset=utf-8"
    fi
 done

echo -e "${YLW}Configuring Dynatrace-Kubernetes integration${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/kubernetes/credentials" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$CONNECTION_CONFIG")
echo -e "${YLW}$RESPONSE${NC}"