#!/bin/bash

print() {
  echo -n -e "\e[1m$1\e[0m....."
  echo -e "\n\e[31m============================ $1 ======================\e[0m"
}
stat() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCESS\e[0m"
    else
      echo -e "\e[1;31mFAILURE\e[0m"
      echo -e "\e[1;33m check the logs in $LOG\e[0m"
      exit 1
      fi

}
LOG=/tmp/roboshop.log
rm -f $LOG

NODEJS() {

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

print "Download ${COMPONENT_NAME}"
curl -s -L -o /tmp/${COMPONENT}.zip  "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
stat $?

print "Remove old content"
rm -rf /home/roboshop/${COMPONENT}
stat $?

print "Unzip a file"
unzip -o -d /home/roboshop /tmp/${COMPONENT}.zip &>>$LOG
stat $?

print "Copy the content"
mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT}
stat $?

print "Install nodejs dependencies"
cd /home/roboshop/${COMPONENT}
npm install --unsafe-perm &>>$LOG
stat $?

print "Fix APP permision"
chown -R roboshop:roboshop /home/roboshop/${COMPONENT}
stat $?

print "Update Listner of ${COMPONENT_NAME}"
sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" -e "s/REDIS_ENDPOINT/redis.roboshop.internal/" -e "s/MONGO_ENDPOINT/mongodb.roboshop.internal/" -e "s/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/" /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
stat $?

print "copy systemd file"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

print "Start ${COMPONENT_NAME} services"
systemctl daemon-reload &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG
stat $?


}

MONGO_CONNECTION() {

  print "Checking connected status of mongodb"
  STAT=$(curl -s localhost:8080/health | jq .mongo)
  if [ "$STAT" == "true" ]; then
    stat 0
    else
      stat 1
   fi

}

REDIS() {

print "Checking connected status of redis"
 STAT=$(curl -s localhost:8080/health | jq .redis)
  if [ "$STAT" == "true" ]; then
    stat 0
  else
      stat 1
   fi
}
