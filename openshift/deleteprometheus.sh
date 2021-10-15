#!/bin/bash

oc delete -f prometheus-imagestream.yaml
oc delete -f prometheus-build.yaml
oc delete -f prom-data-persistentvolumeclaim.yaml
oc delete -f prometheus-deploymentconfig.yaml
oc delete -f prometheus-route.yaml
oc delete -f prometheus-service.yaml
