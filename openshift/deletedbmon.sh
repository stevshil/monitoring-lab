#!/bin/bash

oc delete -f dbclient-imagestream.yaml
oc delete -f dbclient-build.yaml
oc delete -f dbclient-deploymentconfig.yaml
