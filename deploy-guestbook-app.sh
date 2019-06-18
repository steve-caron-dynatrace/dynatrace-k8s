#!/bin/bash

kubectl create namespace guestbook

kubectl apply -f guestbook-app/
#kubectl expose svc/frontend

kubectl -n guestbook create rolebinding default-view --clusterrole=view --serviceaccount=guestbook:default
