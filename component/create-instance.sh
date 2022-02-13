#!/bin/bash

COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | wc -l)

if [ $COUNT -eq 0 ]; then

aws ec2 run-instances --image-id ami-0d997c5f64a74852c --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Values=$1}]" | jq

else
  echo "Instance already exists"

  fi





