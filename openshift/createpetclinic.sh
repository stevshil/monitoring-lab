#!/bin/bash

oc apply -f petclinic-imagestream.yaml
oc apply -f petclinic-build.yaml
oc apply -f petclinic-deploymentconfig.yaml
oc apply -f petclinic-route.yaml
oc apply -f petclinic-service.yaml
oc start-build petclinic
