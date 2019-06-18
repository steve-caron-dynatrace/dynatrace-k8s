#!/bin/bash


kubectl patch deployment carts -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment catalogue -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment front-end -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment orders -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment payment -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment queue-master -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment rabbitmq -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment shipping  -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment user -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'


kubectl patch deployment carts -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment catalogue -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment front-end.stable -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment orders -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment payment -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment queue-master -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment rabbitmq -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment shipping  -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'
kubectl patch deployment user -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "true"}}}}}'

sleep 20s
oc get po --all-namespaces -l product=sockshop
