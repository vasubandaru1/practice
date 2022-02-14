#!/bin/bash

source component/common.sh

print "Download mongodb.repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
stat $?

print "Install Mongodb"
yum install -y mongodb-org &>>$LOG
stat $?

print "Update Listners in conf"
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOG
stat $?

print "Enable the mongod"
systemctl enable mongod &>>$LOG
stat $?

print "Restart the mongod"
systemctl restart mongod &>>$LOG
stat $?

print "Download the schema "
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
stat $?

print "Extract the file"
unzip -o -d /tmp /tmp/mongodb.zip &>>$LOG
stat $?

print "Load schema"
cd /tmp/mongodb-main
mongo < catalogue.js &>>$LOG
mongo < users.js &>>$LOG
stat $?