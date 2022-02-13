#!/bin/bash

aws ec2 run-instances --image-id ami-0d997c5f64a74852c --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq