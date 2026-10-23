#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/roboshop"
logs_file="${logs_folder}/${0}.log"
domain_name="opsify.online"
scripts_dir=$(dirname "$(realpath "$0")")
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access.."
    exit 1
fi

mkdir -p $logs_folder

timestamp(){
    date "+%F %T" 
}

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(timestamp) [ERROR] ${2}..${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "$(timestamp) [INFO] ${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

echo "$(timestamp) [INFO] ==== Script started Execution =====" | tee -a $logs_file

dnf install golang -y &>> $logs_file
go version &>> $logs_file
validate $? "Installing Java and Maven"

id roboshop &>> $logs_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $logs_file
    validate $? "Creating system user"
else
    echo -e "$(timestamp) [INFO] System user roboshop already exist...${Y}SKIPPING${N}"
fi

rm -rf /app
validate $? "Removing old code"

mkdir -p /app
validate $? "Creating app directory"

curl -L -o /tmp/dispatch.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/dispatch-v4.zip &>> $logs_file
validate $? "Downloading dispatch"

cd /app
unzip /tmp/dispatch.zip
validate $? "unzipping the packages"

cd /app
go build -o dispatch .
validate $? "downloading the packages"

#sed -i "s/DOMAIN_NAME/$domain_name/g" "$scripts_dir/dispatch.service"
sed -i \
-e "s|<RABBITMQ-SERVER-IPADDRESS>|rabbitmq.$domain_name|g" \
"$scripts_dir/dispatch.service"
cp "$scripts_dir/dispatch.service" /etc/systemd/system/dispatch.service

systemctl daemon-reload &>> $logs_file
systemctl enable dispatch &>> $logs_file
systemctl restart dispatch
validate $? "Restarting/Starting dispatch"


echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ==== Script completed Execution =====" | tee -a $logs_file