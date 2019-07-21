#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

type jq &> /dev/null

if [ $? -ne 0 ]
	then
	echo "Please install the 'jq' command: sudo apt-get install jq"
	exit 1
fi

if [ -z $1 ]
	then
  	echo "Please provide tenant url"
		echo ""
		echo "e.g. tno12345.live.dynatrace.com"
		echo ""
		exit 1
	else
		TENANT=$1
fi

if [ -z $2 ]
	then
  	echo "Please provide paas token"
		echo ""
		echo "e.g. DaXdFASZcd4567sdggsdg"
		echo ""
		exit 1
	else
		PAAS=$2
fi

SGW=$(curl https://$TENANT/api/v1/deployment/installer/agent/connectioninfo?Api-Token=$PAAS) 
curl https://$TENANT/api/v1/deployment/installer/agent/connectioninfo?Api-Token=$PAAS > SGW.txt
jq .communicationEndpoints SGW.txt > commpts.txt

echo "---
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: dynatrace-oneagent-hostnames
spec:
  hosts:
  - $TENANT"  > service_entry_oneagent.yml
  
sed -i '/\[/d' ./commpts.txt
sed -i '/\]/d' ./commpts.txt
sed -i 's/\"//g' ./commpts.txt
sed -i 's/ //g' ./commpts.txt
sed -i 's/https:\/\///g' ./commpts.txt
sed -i 's/,//g' ./commpts.txt
sed -i 's/\/communication//g' ./commpts.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "  - $line" >> service_entry_oneagent.yml
done < "commpts.txt"

echo "  location: MESH_EXTERNAL
  ports:
  - number: 443
    name: HTTPS
    protocol: HTTPS
  resolution: DNS
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: dynatrace-oneagent-hostnames
spec:
  hosts:
  - $TENANT" >> service_entry_oneagent.yml

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "  - $line" >> service_entry_oneagent.yml
done < "commpts.txt"

echo "  tls:
  - match:
    - port: 443
      sni_hosts:
      - $TENANT
    route:
    - destination:
        host: $TENANT
        port:
          number: 443
          name: HTTPS" >> service_entry_oneagent.yml

while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "  - match:
    - port: 443
      sni_hosts:" >> service_entry_oneagent.yml
    echo "      - $line" >> service_entry_oneagent.yml
	echo "    route:
    - destination:" >> service_entry_oneagent.yml
	echo "        host: $line" >> service_entry_oneagent.yml
	echo "        port:
          number: 443
          name: HTTPS" >> service_entry_oneagent.yml
done < "commpts.txt"

