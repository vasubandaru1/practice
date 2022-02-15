#!/bin/bash



source component/common.sh

COMPONENT_NAME=Cataloge
COMPONENT=catalogue

NODEJS

sleep 5

print "Checking connected status of mongodb"
STAT=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STAT" == "true" ]; then
  stat 0
  else
    stat 1
 fi


