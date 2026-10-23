#!/bin/bash
 user_id=$(id -u)
 logs_folder="/var/log/roboshop"
 logs_file="${logs_folder}/${0}.log"
 domain_name="opsify.online"
 scripts_dir="$(dirname "$(realpath "$0")")"
 R="\e[31m"
 G="\e[32m"
 Y="\e[33m"
 N="\e[0m"

if [$user_id -ne 0 ]; then
    echo "ERROR:Please run this code with sudo access.."
    exit 1
fi


mkdir -p $logs_folder

timestamp(){
    date "+%F %T"
}


validate(){
    if [ $1 -ne 0 ];then
        echo -e "$(timestamp) [ERROR] ${2}...${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "$(timestamp) [INFO] ${2}...${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

echo  "$(timestamp) [INFO] ==== Script Execution Started =======" | tee -a $logs_file

dnf module disable nodejs -y  &>> $logs_file
dnf module enable nodejs:24 -y &>> $logs_file
dnf install nodejs -y &>> $logs_file
validate $?  "Installing nodejs:24"


id roboshop &>> $logs_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $logs_file
    validate $? "Creating system user"
else
    echo -e "$(timestamp) [info] system user already exist...${Y}SKIPPPING${N}"
fi

rm -rf /app
validate $? "Removing old Files"

mkdir -p /app
validate $? "creating '/app' directory"

curl -L -o /tmp/user.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/user-v4.zip &>> $logs_file
validate $? "Downloading User Info"

cd /app
unzip /tmp/user.zip &>> $logs_file
validate $? "unzipping user Info"

npm install &>> $log_file
validate $? "Installing Dependencies"

sed -i "s/DOMAIN_NAME/$domain_name/g" "$scripts_dir/user.service"
cp "$scripts_dir/user.service" /etc/systemd/system/user.service


systemctl daemon-reload  &>> $logs_file
systemctl enable user &>> $logs_file
systemctl start user  &>> $logs_file
validate $? "Reloaded daemon, enabled user and started user"

systemctl restart user
validate $? "Restarted the User Service"


echo "$(timestamp)  [INFO] script Completed in $SECONDS seconds"
echo "$(timestamp) [INFO]  === Script Execution Completed ===" | tee -a &>> $logs_file






