#!/bin/bash

oc apply -f prometheus-imagestream.yaml
oc apply -f prometheus-build.yaml
oc apply -f prom-data-persistentvolumeclaim.yaml
oc apply -f prometheus-deploymentconfig.yaml
oc apply -f prometheus-route.yaml
oc apply -f prometheus-service.yaml
oc start-build prometheus
