#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

## Uninstall Istio

cd $CURRENT_DIR/istio
./istio-uninstall.sh

## Uninstall the OneAgent and the Operator

cd $CURRENT_DIR/dynatrace/kubernetes
./uninstall-operator_oneagent.sh

## Uninstall ActiveGate
./uninstall-activegate.sh

## Remove Dynatrace-Kubernetes integration
./delete-k8s-integration-configuration.sh

## Delete EasyTravel app
cd $CURRENT_DIR/easytravel/scripts
./delete_easytravel.sh

## Remove Dynatrace configuration for EasyTravel
cd $CURRENT_DIR/easytravel/dynatrace
./delete-dt-webapps-configs.sh

## Delete Sock Shop app
cd $CURRENT_DIR/sockshop/scripts
./delete-sockshop.sh

## Remove Dynatrace configuration for Sock Shop
cd $CURRENT_DIR/sockshop/dynatrace
./delete-dt-webapps-synth-configs.sh

