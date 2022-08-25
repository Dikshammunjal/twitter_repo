#!/bin/sh -x

DOCKERURL=$1
USERNAME=$2
PASSWORD=$3
EMAIL=$4
changens=$5
changedeploymentname=$6
changeimage=$7
changeport=$8
changeservice=$9




kubectl create ns $changens

kubectl create secret docker-registry ocirloginsecret --docker-server=$DOCKERURL  --docker-username=''$USERNAME'' --docker-password=''$PASSWORD''  --docker-email=''$EMAIL'' -n $changens


cp deployment_template.yaml "$changedeploymentname"_deployment_template.yaml

 /usr/bin/sed -i -e 's%changens%'$changens'%g' -e 's%changedeploymentname%'$changedeploymentname'%g' -e 's%changeimage%'$changeimage'%g' -e 's%changeport%'$changeport'%g' -e 's%changeservice%'$changeservice'%g' "$changedeploymentname"_deployment_template.yaml

kubectl apply -f "$changedeploymentname"_deployment_template.yaml                                                                 
