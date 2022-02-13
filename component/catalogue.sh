#!/bin/bash

source component/common.sh

print "Install nodejs"
 yum install nodejs make gcc-c++ -y &>>$LOG
 stat $?

print "Add roboshop user"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
  echo "user already exists"
  else
useradd roboshop
fi
stat $?

print "Download catalogue"
curl -s -L -o /tmp/catalogue.zip  "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
stat $?

print "Remove old content"
rm -rf /home/roboshop/catalogue
stat $?

print "Unzip a file"
unzip -o -d /home/roboshop/. /tmp/catalogue.zip
stat $?
exit
print "mv"
mv

$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue
$ npm install
NOTE: We need to update the IP address of MONGODB Server in systemd.service file
Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue