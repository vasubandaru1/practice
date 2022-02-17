#!/bin/bash



source component/common.sh

COMPONENT_NAME=Shipping
COMPONENT=shipping

 print "Install Maven"
  yum install maven -y &>>$LOG
  stat $?

ROBOSHOP_USER

print "Download ${COMPONENT_NAME}"
  curl -s -L -o /tmp/${COMPONENT}.zip  "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  stat $?

  print "Unzip a file"
  unzip -o -d /home/roboshop /tmp/${COMPONENT}.zip &>>$LOG
  stat $?

#  if [ "$1" == "/home/roboshop" ]; then
#    print "Remove old content"
#    rm -rf /home/roboshop/${COMPONENT}
#    stat $?
#    print "Copy the content"
#mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT}
#stat $?
#fi

print "Make Mave package"
cd /home/roboshop/${Component}
mvn clean package &>>$LOG && mv target/shipping-1.0.jar shipping.jar &>>$LOG
stat $?
print "Fix APP permision"
  chown -R roboshop:roboshop /home/roboshop/${COMPONENT}
  stat $?

  print "Update Listner of ${COMPONENT_NAME}"
  sed -i -e "s/CARTENDPOINT/cart.roboshop.internal/" -e "s/DBHOST/mysql.roboshop.internal/" /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
  stat $?

  print "copy systemd file"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  stat $?

  print "Start ${COMPONENT_NAME} services"
  systemctl daemon-reload &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG
  stat $?

