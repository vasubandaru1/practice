#!/bin/bash

source component/common.sh

print "Install Redis repos"
rpm -qa | grep wget | yum -y install wget | echo $? &>>$LOG

if [ $? == 0 ]; then
print "repos already exists"

else
   yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
fi
stat $?

print "Enable redis repos"
yum-config-manager --enable remi &>>$LOG
stat $?

print "Install Redis"
yum install redis -y &>>$LOG
stat $?

print "Update Redis Listner"
sed -i -e "s/127.0.0.1/0.0.0.0/"  /etc/redis/redis.conf /etc/redis.conf &>>$LOG
stat $?

print "Restart redis services"
systemctl enable redis &>>$LOG && systemctl restart redis &>>$LOG
stat $?