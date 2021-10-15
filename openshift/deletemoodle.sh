#!/bin/bash

oc delete -f moodle-imagestream.yaml
oc delete -f moodle-build.yaml
oc delete -f moodle-data-persistentvolumeclaim.yaml
oc delete -f moodle-deploymentconfig.yaml
oc delete -f moodle-route.yaml
oc delete -f moodle-service.yaml
