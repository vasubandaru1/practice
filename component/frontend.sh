#!/bin/bash

source component/common.sh

print "Installing nginx"
yum install nginx -y &>>$LOG
stat $?

print "Enabling nginx"
systemctl enable nginx &>>$LOG
stat $?

print "Starting nginx"
systemctl start nginx &>>$LOG
stat $?

print "Downloading zipfile"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
stat $?

cd /usr/share/nginx/html

rm -rf *

unzip /tmp/frontend.zip

 mv frontend-main/* .

 mv static/* .

 rm -rf frontend-master static README.md

 mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx