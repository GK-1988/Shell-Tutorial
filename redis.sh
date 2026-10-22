#!/bin/bash

user_id="$(id -u)"
logs_folder="/var/log/roboshop"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $user_id -ne 0 ]; then
    echo "ERROR: Please run this script with sudo user.."
    exit 1
fi

mkdir -p $logs_folder

timestamp(){
    date +"%F %T"
}


validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(timestamp) [ERROR] ${2}...${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "$(timestamp) [INFO] ${2}...${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

echo "$(timestamp) [INFO] =====Script Started Execution====" | tee -a $logs_file

dnf module disable redis -y &>> $logs_file
dnf module enable redis:7 -y &>> $logs_file
dnf install redis -y  &>> $logs_file
validate $? "Installaing Redis"

sed -i -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "Allow the remote connection to Redis"

systemctl enable redis &>> $logs_file
systemctl start redis
validate $? "Enabled and started Redis"

systemctl status redis |tee -a $logs_file
ss -lntp | grep 6379  |tee -a $logs_file
redis-cli ping |tee -a $logs_file

echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ==== Script completed Execution =====" | tee -a $logs_file
