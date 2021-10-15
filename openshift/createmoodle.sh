#!/bin/bash

oc apply -f moodle-imagestream.yaml
oc apply -f moodle-build.yaml
oc apply -f moodle-data-persistentvolumeclaim.yaml
oc apply -f moodle-deploymentconfig.yaml
oc apply -f moodle-route.yaml
oc apply -f moodle-service.yaml
oc start-build moodle
