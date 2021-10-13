#!/bin/bash

oc delete -f petclinic-imagestream.yaml
oc delete -f petclinic-build.yaml
oc delete -f petclinic-deploymentconfig.yaml
oc delete -f petclinic-route.yaml
oc delete -f petclinic-service.yaml
