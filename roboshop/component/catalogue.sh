#!/bin/bash



source component/common.sh
cat $0 | grep ^print | awk -F '"' '{print $2}'

exit
print "Install nodejs"
yum install gcc-c++ make -y &>>$LOG
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash - &>>$LOG
sleep 20
yum install nodejs -y &>>$LOG
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
rm -rf /home/roboshop/catalogue
stat $?

print "Unzip a file"
unzip -o -d /home/roboshop /tmp/catalogue.zip &>>$LOG
stat $?

print "Copy the content"
mv /home/roboshop/catalogue-main /home/roboshop/catalogue
stat $?

print "Install nodejs dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
stat $?

print "Fix APP permision"
chown -R roboshop:roboshop /home/roboshop/catalogue
stat $?

print "Update Listner of mongodb"
sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" /home/roboshop/catalogue/systemd.service &>>$LOG
stat $?

print "copy systemd file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
stat $?

print "Start Catalogue services"
systemctl daemon-reload && systemctl start catalogue && systemctl enable catalogue &>>$LOG
stat $?

sleep 5

print "Checking connected status of mongodb"
STAT=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STAT" == "true" ]; then
  stat 0
  else
    stat 1
 fi


