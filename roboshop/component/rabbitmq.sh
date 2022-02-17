#!/bin/bash



source component/common.sh

COMPONENT_NAME=Rabbitmq
COMPONENT=rabbitmq

print "Install Erlang"
 yum list installed | grep erlang &>>$LOG

 if [ $? -ne 0 ]; then
   yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG
stat $?

print "Setup YUM repositories "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
stat $?

print "Install RabbitMQ"
yum install rabbitmq-server -y &>>$LOG
stat $?
exit
#Start RabbitMQ
# systemctl enable rabbitmq-server
# systemctl start rabbitmq-server
RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application.

Create application user
# rabbitmqctl add_user roboshop roboshop123
# rabbitmqctl set_user_tags roboshop administrator
# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"