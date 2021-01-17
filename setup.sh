#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

## Deploy Istio

cd $CURRENT_DIR/istio
/bin/bash ./istio-install.sh

## Deploy the OneAgent Operator

cd $CURRENT_DIR/dynatrace/kubernetes
kubectl create namespace dynatrace
kubectl apply -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml
DT_API_TOKEN=$(grep "DT_API_TOKEN=" ../../configuration.conf | sed 's~DT_API_TOKEN=[ \t]*~~')
DT_PAAS_TOKEN=$(grep "DT_PAAS_TOKEN=" ../../configuration.conf | sed 's~DT_PAAS_TOKEN=[ \t]*~~')
kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken="$DT_API_TOKEN --from-literal="paasToken="$DT_PAAS_TOKEN
./config-cr.sh
kubectl apply -f cr.yaml
sleep 70
kubectl get po -n dynatrace

## Deploy ActiveGate
./deploy-activegate.sh

## Configure Dynatrace-Kubernetes integration
./config-k8s-integration.sh

## Deploy EasyTravel app
cd $CURRENT_DIR/easytravel/scripts
./create_easytravel.sh

## Deploy Sock Shop app
cd $CURRENT_DIR/sockshop/scripts
./deploy-sockshop.sh -istio
./get-sockshop-urls.sh -istio
./create-sockshop-accounts.sh

## Configure Dynatrace for Sock Shop
cd $CURRENT_DIR/sockshop/dynatrace
./config-dt-webapps-synth.sh -istio

