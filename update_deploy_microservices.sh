#!/bin/sh -x

changens=$1
changedeploymentname=$2
changeimage=$3
changeport=$4
changeservice=$5
template=$6

 cp deployment_template.yaml "$changedeploymentname"_deployment_template.yaml

 /usr/bin/sed -i -e 's/changens/'$changens'/g' -e 's/changedeploymentname/'$changedeploymentname'/g' -e 's/changeimage/'$changeimage'/g' -e 's/changeport/'$changeport'/g' -e 's/changeservice/'$changeservice'/g' "$changedeploymentname"_deployment_template.yaml

kubectl apply -f "$changedeploymentname"_deployment_template.yaml
