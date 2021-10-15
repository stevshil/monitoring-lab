#!/bin/bash

oc delete -f grafana-imagestream.yaml
oc delete -f grafana-build.yaml
oc delete -f grafana-deploymentconfig.yaml
oc delete -f grafana-route.yaml
oc delete -f grafana-service.yaml
