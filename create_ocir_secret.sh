#!/bin/sh -x

DOCKERURL=$1
USERNAME=$2
PASSWORD=$3
EMAIL=$4




kubectl create secret docker-registry ocirloginsecret --docker-server=$DOCKERURL  --docker-username=''$USERNAME'' --docker-password=''$PASSWORD''  --docker-email=''$EMAIL''
