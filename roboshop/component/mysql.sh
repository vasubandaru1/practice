#!/bin/bash



source component/common.sh

COMPONENT_NAME=MySQL
COMPONENT=mysql


print "Setup ${COMPONENT_NAME} Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
stat $?

print "Install ${COMPONENT_NAME}"
yum remove mariadb-libs -y  &>>$LOG && yum install ${COMPONENT}-community-server -y &>>$LOG
stat $?

print "Start ${COMPONENT_NAME}"
systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
stat $?

DEFAULT_PASSWORD=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
NEW_PASSWORD=RoboShop@1

echo 'show databases;' | mysql -uroot -p"${NEW_PASSWORD}" &>>$LOG
if [ $? -ne 0 ]; then
  print "changing default password"
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_PASSWORD}';\nuninstall plugin validate_password;" >/tmp/pass.sql
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>$LOG

  fi

DOWNLOAD '/tmp'

print "Load Schema"
cd /tmp/mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>$LOG