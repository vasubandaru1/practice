#!/bin/bash

print() {
  echo -n -e "\e[1m$1\e[0m"
  echo -e "\n\e[31m============================ $1 ======================\e[0m"
}
stat() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCESS\e[0m"
    else
      echo -e "\e[1;31mFAILURE\e[0m"
      echo -e "\e[1;33m check the logs in $LOG\e[0m"
      exit1
      fi

}
LOG=/tmp/roboshop.log
rm -f $LOG

print "Installing nginx"
yum install nginxx -y &>>$LOG
stat $?

print "Enabling nginx"
systemctl enable nginx &>>$LOG
stat $?

print "Starting nginx"
systemctl start nginx &>>$LOG
stat $?

print "Downloading zipfile"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
stat $?
exit
cd /usr/share/nginx/html

rm -rf *

unzip /tmp/frontend.zip

 mv frontend-main/* .

 mv static/* .

 rm -rf frontend-master static README.md

 mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx