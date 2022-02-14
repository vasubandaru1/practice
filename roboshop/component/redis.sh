#!/bin/bash

source component/common.sh

print "Install Redis repos"
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
stat $?

print "Enable redis repos"
yum-config-manager --enable remi &>>$LOG
stat $?

print "Install Redis"
yum install redis -y &>>$LOG
stat $?

print "Update Redis Listner"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf &>>$LOG
stat $?

print "Restart redis services"
systemctl enable redis && systemctl restart redis &>>$LOG
stat $?