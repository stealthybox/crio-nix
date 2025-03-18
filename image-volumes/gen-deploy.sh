#!/usr/bin/env bash

STORE_PATHS="$(ls -d /nix/store/*/ | xargs -n1 basename)"
NIX_DB_OCI_REPO="localhost:5001/stealthybox/nix-db:codespaces-scale"
NIX_STORE_OCI_REPO="localhost:5001/stealthybox/nix-store"

echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-volumes
spec:
  replicas: 1
  selector:
    matchLabels:
      app: image-volumes
  template:
    metadata:
      labels:
        app: image-volumes
    spec:
      containers:
      - name: shell
        command: ["sleep", "infinity"]
        image: alpine

        volumeMounts:
          - name: volume
            mountPath: /volume

          - name: nix-db
            mountPath: /nix/var/nix/db
"

i=0
for storepath in $STORE_PATHS; do
let i++
echo "
          - name: nix-store-${i}
            mountPath: /nix/store/${storepath}
"
done

echo "
      volumes:
      - name: volume
        image:
          reference: quay.io/crio/artifact:v1
          pullPolicy: IfNotPresent

      - name: nix-db
        image:
          reference: ${NIX_DB_OCI_REPO}
          pullPolicy: IfNotPresent
"

i=0
for storepath in $STORE_PATHS; do
let i++
echo "
      - name: nix-store-${i}
        image:
          reference: ${NIX_STORE_OCI_REPO}:${storepath}
          pullPolicy: IfNotPresent
"
done
