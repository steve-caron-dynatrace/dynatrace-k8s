#!/bin/bash


kubectl patch deployment carts -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment catalogue -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment front-end -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment orders -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment payment -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment queue-master -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment rabbitmq -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment shipping  -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment user -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'


kubectl patch deployment carts -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment catalogue -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment front-end.stable -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment orders -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment payment -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment queue-master -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment rabbitmq -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment shipping  -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment user -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'

sleep 20s
kubectl get po --all-namespaces -l product=sockshop
