#!/bin/bash

kubectl  get pods 
PODMAN=$( oc   get pods  --no-headers -o custom-columns=":metadata.name" --field-selector status.phase=Running |grep oracle)
echo $PODMAN
kubectl  exec -it  $PODMAN  --  bash -c "  rm -rf /tmp/*.sql "
kubectl  cp  bcrm-oracle-part00.sql   $PODMAN:/tmp/bcrm-oracle-part00.sql
kubectl  cp  bcrm-oracle-part01.sql   $PODMAN:/tmp/bcrm-oracle-part01.sql