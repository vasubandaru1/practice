#!/bin/bash

source component/common.sh

print "Install nodejs"
yum install gcc-c++ make nodejs   -y &>>$LOG
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash - &>>$LOG
SLEEP 10
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
curl -s -L -o /tmp/catalogue.zip  "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
stat $?

print "Remove old content"
rm -rf /home/ &>>$LOG
stat $?

print "Unzip a file"
unzip -o -d /home/roboshop /tmp/catalogue.zip &>>$LOG
stat $?

print "Copy the content"
mv /home/roboshop/catalogue-main /home/roboshop/catalogue &>>$LOG
stat $?

print "Install nodejs dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
stat $?

print "Update Listner in systemd.service"
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/systemd &>>$LOG
stat $?

print "Fix APP permision"
chown -R roboshop:roboshop /home/roboshop
stat $?
exit

NOTE: We need to update the IP address of MONGODB Server in systemd.service file
Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue