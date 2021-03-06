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

DOWNLOAD() {
  print "Download ${COMPONENT_NAME}"
  curl -s -L -o /tmp/${COMPONENT}.zip  "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  stat $?

  print "Unzip a file"
  unzip -o -d $1 /tmp/${COMPONENT}.zip &>>$LOG
  stat $?

  if [ "$1" == "/home/roboshop" ]; then
    print "Remove old content"
    rm -rf /home/roboshop/${COMPONENT}
    stat $?
    print "Copy the content"
mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT}
stat $?
fi
 }

ROBOSHOP_USER() {

print "Add roboshop user"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
  echo "user already exists" &>>$LOG
else
  sleep 5
   useradd roboshop &>>$LOG
fi
stat $?
}

SYSTEMD() {
  print "Fix APP permision"
  chown -R roboshop:roboshop /home/roboshop/${COMPONENT}
  stat $?

  print "Update Listner of ${COMPONENT_NAME}"
  sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" -e "s/REDIS_ENDPOINT/redis.roboshop.internal/" -e "s/MONGO_ENDPOINT/mongodb.roboshop.internal/" -e "s/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/" -e "s/CARTENDPOINT/cart.roboshop.internal/" -e "s/DBHOST/mysql.roboshop.internal/" -e "s/CARTHOST/cart.roboshop.internal/" -e "s/USERHOST/user.roboshop.internal/" -e "s/AMQPHOST/rabbitmq.roboshop.internal/" /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
  stat $?

  print "copy systemd file"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  stat $?

  print "Start ${COMPONENT_NAME} services"
  systemctl daemon-reload &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG
  stat $?
}

MAVEN() {
  print "Install Maven"
  yum install maven -y &>>$LOG
  stat $?

ROBOSHOP_USER

DOWNLOAD '/home/roboshop'

print "Make Mave package"
cd /home/roboshop/${Component}
mvn clean package &>>$LOG && mv target/shipping-1.0.jar shipping.jar &>>$LOG
stat $?

SYSTEMD

}

NODEJS() {

  print "Install nodejs"
yum install gcc-c++ make -y &>>$LOG
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash - &>>$LOG
sleep 20
yum install nodejs -y &>>$LOG
 stat $?

ROBOSHOP_USER



DOWNLOAD '/home/roboshop'

print "Install nodejs dependencies"
cd /home/roboshop/${COMPONENT}
npm install --unsafe-perm &>>$LOG
stat $?

SYSTEMD

}
PYTHON() {
  print "Install Python 3"
  yum install python36 gcc python3-devel -y &>>$LOG
  stat $?

 ROBOSHOP_USER
 DOWNLOAD '/home/roboshop'

 print "Install the dependencies"
  cd /home/roboshop/payment
  pip3 install -r requirements.txt &>>$LOG
  stat $?

USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)

print "Update ${COMPONENT_NAME} service"
sed -i -e "/uid/ c uid = $USER_ID" -e "/gid/ c gid = $GROUP_ID" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>$LOG
stat $?

SYSTEMD

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

  print "connection status of redis"
  STAT=$(curl -s localhost:8080/health | jq .redis)
  if [ "$STAT" == "true" ]; then
    stat 0
    else
      stat 1
      fi
}