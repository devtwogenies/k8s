#!/bin/bash

helm install postgresql \
--set global.postgresql.postgresqlPassword=_pass123_ \
--set securityContext.fsGroup=0,containerSecurityContext.runAsUser=0 \
--set persistence.existingClaim=data-postgresql,image.tag=13.1.0-debian-10-r29 \
bitnami/postgresql

kubectl port-forward  --address 192.168.10.10 --namespace default svc/postgresql 5432:5432 &

