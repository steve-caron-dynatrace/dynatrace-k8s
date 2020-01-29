#!/bin/bash


PROD_FRONTEND_URL=http://$(kubectl describe svc front-end -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//'):8080
PROD_CARTS_URL=http://$(kubectl describe svc carts -n production | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
DEV_FRONTEND_URL=http://$(kubectl describe svc front-end -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//'):8080
DEV_CARTS_URL=http://$(kubectl describe svc carts -n dev | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')

sed -i -r 's~PROD_FRONTEND_URL=(.*)~PROD_FRONTEND_URL\='"$PROD_FRONTEND_URL"'~' ./configs.txt
sed -i -r 's~PROD_CARTS_URL=(.*)~PROD_CARTS_URL\='"$PROD_CARTS_URL"'~' ./configs.txt  
sed -i -r 's~DEV_FRONTEND_URL=(.*)~DEV_FRONTEND_URL\='"$DEV_FRONTEND_URL"'~' ./configs.txt
sed -i -r 's~DEV_CARTS_URL=(.*)~DEV_CARTS_URL\='"$DEV_CARTS_URL"'~' ./configs.txt         



