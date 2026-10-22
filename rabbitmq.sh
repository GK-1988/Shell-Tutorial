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

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "Copying the Rabbitmq Repo"

dnf install erlang rabbitmq-server -y &>> $logs_file
validate $? "Installing Rabbitmq Server"

systemctl enable rabbitmq-server  &>> $logs_file
systemctl start rabbitmq-server  &>> $logs_file
validate $? "Enabled and Started the Rabbitmq Server"


rabbitmqctl list_users | grep -qw "roboshop"
if [$? -ne 0 ]; then
    rabbitmqctl add_user roboshop roboshop123 &>> $logs_file
    validate $? "creating roboshp user with password"
else
    echo -e "$(timestamp) [INFO] Rabbitmq user already exist...${Y}SKIPPING${N}"
fi


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $logs_file
validate $? "Setting up all permissions to roboshop user"

echo "=========Verification==========="

systemctl status rabbitmq-server |tee -a $logs_file
ss -lntp | grep 5672 | tee -a $logs_file
rabbitmqctl list_users | tee -a $logs_file
validate $? "Verification completed Successfully"

echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ==== Script completed Execution =====" | tee -a $logs_file
