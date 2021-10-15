#!/bin/bash

oc apply -f grafana-imagestream.yaml
oc apply -f grafana-build.yaml
oc apply -f grafana-deploymentconfig.yaml
oc apply -f grafana-route.yaml
oc apply -f grafana-service.yaml
oc start-build grafana
