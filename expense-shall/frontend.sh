#!/bin/bash

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then 
        echo "Please run this script with root priveleges"
        exit 1
    fi
}
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is ... $R FAILED $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi  
}

echo " script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf install nginx -y &>>LOG_FILE
VALIDATE $? "Install nginx"
systemctl enable nginx &>>LOG_FILE
VALIDATE $? "enable nginx"
systemctl start nginx &>>LOG_FILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>LOG_FILE
VALIDATE $? "extract frontend code"

cp /home/ec2-user/devops-classed-by-me/expense-shall/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "copied expense conf"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"