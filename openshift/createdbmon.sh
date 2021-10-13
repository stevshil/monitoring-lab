#!/bin/bash

oc apply -f dbclient-imagestream.yaml
oc apply -f dbclient-build.yaml
oc apply -f dbclient-deploymentconfig.yaml
oc start-build dbclient
