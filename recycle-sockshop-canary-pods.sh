#!/bin/bash

kubectl patch deployment front-end.canary -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'

sleep 20s
kubectl get po -o wide
