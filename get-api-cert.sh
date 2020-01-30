#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo ""    
read -p "Please enter your Kubernetes API endpoint URL: " API_ENDPOINT_URL
echo "" 

read -p "API Endpoint URL = ${API_ENDPOINT_URL} . Is this correct? (y/n): " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	API_SERVER_PORT="$(echo $API_ENDPOINT_URL | sed -e "s/https:\/\///"):443"
	echo $API_SERVER_PORT
	echo ""

	echo Q | openssl s_client -connect $API_SERVER_PORT 2>/dev/null | openssl x509 -outform PEM > dt_k8s_api.pem
	
fi

	

