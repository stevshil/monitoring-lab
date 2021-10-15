#!/bin/bash

oc delete -f database-imagestream.yaml
oc delete -f database-build.yaml
oc delete -f db-data-persistentvolumeclaim.yaml
oc delete -f database-deploymentconfig.yaml
