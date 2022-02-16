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

DEFAULT_PASSWORD=$( grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
NEW_PASSWORD=roboshop123

echo 'show databases;' | mysql -uroot -p"${NEW_PASSWORD}" &>>$LOG
if [ $? -ne 0 ]; then
  print "changing default password"
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_PASSWORD}';\nuninstall plugin validate_password;" >/tmp/pass.sql
  mysql -uroot -p"${NEW_PASSWORD}" </tmp/pass.sql &>>$LOG

  fi

exit
Now a default root password will be generated and given in the log file.
# grep temp /var/log/mysqld.log

Next, We need to change the default root password in order to start using the database service.
# mysql_secure_installation

You can check the new password working or not using the following command.

# mysql -u root -p

Run the following SQL commands to remove the password policy.
> uninstall plugin validate_password;
Setup Needed for Application.
As per the architecture diagram, MySQL is needed by

Shipping Service
So we need to load that schema into the database, So those applications will detect them and run accordingly.

To download schema, Use the following command

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
Load the schema for Services.

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql