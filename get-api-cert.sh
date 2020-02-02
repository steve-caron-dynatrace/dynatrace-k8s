#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo ""    

API_ENDPOINT_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
API_SERVER_PORT="$(echo $API_ENDPOINT_URL | sed -e "s/https:\/\///"):443"
echo -e "${YLW} API server:${NC} ${API_SERVER_PORT}"
echo ""

echo Q | openssl s_client -connect $API_SERVER_PORT 2>/dev/null | openssl x509 -outform PEM > dt_k8s_api.pem
	

	

