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
