#!/bin/bash

source component/common.sh

print "Installing nginx"
yum install nginx -y &>>$LOG
stat $?


print "Downloading zipfile"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
stat $?

print "Remove old html pages"
rm -rf /usr/share/nginx/html/* &>>$LOG

print "Extract files"
unzip -o -d /tmp /tmp/frontend.zip &>>$LOG

print "Copy files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>$LOG
stat $?

print "Copy nginx conf files"
mv tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG

print "Enabling nginx"
systemctl enable nginx &>>$LOG
stat $?

print "Starting nginx"
systemctl start nginx &>>$LOG
stat $?

