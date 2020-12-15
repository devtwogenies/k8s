#!/bin/bash

helm install rabbitmq \
--set auth.username=admin,auth.password=pass123,persistence.existingClaim=data-rabbitmq,podSecurityContext.runAsUser=0,podSecurityContext.fsGroup=0 \
--set rabbitmq.rbacEnabled=false,rabbitmq.plugins=rabbitmq_management \
bitnami/rabbitmq

kubectl port-forward --address 192.168.10.10 --namespace default svc/rabbitmq 15672:15672 &

kubectl port-forward --address 192.168.10.10 --namespace default svc/rabbitmq 5672:5672 &

