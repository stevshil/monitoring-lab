#!/bin/bash

oc apply -f wordpress-imagestream.yaml
oc apply -f wordpress-build.yaml
oc apply -f wordpress-data-persistentvolumeclaim.yaml
oc apply -f wordpress-deploymentconfig.yaml
oc apply -f wordpress-route.yaml
oc apply -f wordpress-service.yaml
oc start-build wordpress
