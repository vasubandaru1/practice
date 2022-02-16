#!/bin/bash

source component/common.sh

COMPONENT_NAME=Mongodb
COMPONENT=mongodb

print "Download mongodb.repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
stat $?

print "Install Mongodb"
yum install -y mongodb-org &>>$LOG
stat $?

print "Update Listners in conf"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf &>>$LOG
stat $?

print "Enable the mongod"
systemctl enable mongod &>>$LOG && systemctl restart mongod &>>$LOG
stat $?

DOWNLOAD '/tmp'

print "Load schema"
cd /tmp/mongodb-main
mongo < catalogue.js &>>$LOG && mongo < users.js &>>$LOG
stat $?