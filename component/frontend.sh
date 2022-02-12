#!/bin/bash

print() {
  echo -e "\e[1m$1\e[0m"
  echo -e "\n\e[31m============================ $1 ======================\e[0m"
}
LOG=/tmp/roboshop.log
rm -rf $LOG

print "Installing nginx"
yum install nginx -y &>>$LOG

print "Enabling nginx"
systemctl enable nginx &>>$LOG

print "Starting nginx"
systemctl start nginx &>>$LOG

print "Downloading zipfile"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
exit

cd /usr/share/nginx/html

rm -rf *

unzip /tmp/frontend.zip

 mv frontend-main/* .

 mv static/* .

 rm -rf frontend-master static README.md

 mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx