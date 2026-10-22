#!/bin/bash

USER_ID="$(id -u)"
logs_folder="/var/log/roboshop"
logs_file="${logs_folder}/${0}/.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ "$user_id" -ne 0 ]; then
    echo "ERROR: Please run this script with sudo user.."
    exit 1
fi

mkdir -p $logs_folder

echo "Script started execution at $(date +"%F %T")" &>> $logs_file

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "${2}...${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "${2}...${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-org -y &>> $logs_file
validate $? "Install mongodb"

systemctl enable mongod &>> $logs_file
systemctl start mongod  &>> $logs_file
validate $? "Enabled and Start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
validate $? "Allow remote connections to MongoDB"

systemctl restart mongod 
validate $? "Restarted MnongoD"
