#!/bin/sh

echo "Setting up easyTravel"
kubectl create namespace easytravel
kubectl -n easytravel create rolebinding default-view --clusterrole=view --serviceaccount=easytravel:default

#!./create.sh
echo "Creating easyTravel"
kubectl create -f ../manifests/easytravel-mongodb-deployment.yaml
kubectl create -f ../manifests/easytravel-mongodb-service.yaml
kubectl create -f ../manifests/easytravel-backend-deployment.yaml
kubectl create -f ../manifests/easytravel-frontend-deployment.yaml
kubectl create -f ../manifests/easytravel-nginx-deployment.yaml
kubectl create -f ../manifests/easytravel-pluginservice-deployment.yaml
kubectl create -f ../manifests/easytravel-pluginservice-service.yaml

echo "Exposing easyTravel"
kubectl create -f ../manifests/easytravel-backend-service.yaml
kubectl create -f ../manifests/easytravel-frontend-service.yaml
kubectl create -f ../manifests/easytravel-nginx-service.yaml
echo "Waiting for 150 seconds before starting loadgen"
sleep 150
kubectl create -f ../manifests/easytravel-loadgen-deployment.yaml

SERVICE_NAME=easytravel-www
NAMESPACE=easytravel

START=$(date +%s)
DIFF=0
# while public domain is not available or more than 10 minutes have elapsed
while [ -z $PUBLIC_DOMAIN ]  && [ $DIFF -lt 600 ];
do
  PUBLIC_DOMAIN=$(kubectl describe svc $SERVICE_NAME -n $NAMESPACE | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  echo -n .
  sleep 4
  NOW=$(date +%s)
  DIFF=$(( $NOW - $START ))
done

echo ""

if [ -z $PUBLIC_DOMAIN ];
then
  echo "SETUP ERROR : EasyTravel service could not get a public IP address"
else
  echo "EasyTravel Public Domain: $PUBLIC_DOMAIN"
fi