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

dnf module disable nodejs -y &>>LOG_FILE
VALIDATE $? "Disable default nodejs"

dnf module enable nodejs:20 -y &>>LOG_FILE
VALIDATE $? "Enable nodejs:20"

dnf install nodejs -y &>>LOG_FILE
VALIDATE $? "Install nodejs"

id expense

if [ $? -ne 0 ]
then
    echo "expense user not exist.. creating it"
    useradd expense
    VALIDATE $? "Creating expense user"
else
    echo "expense user is already exist.. Skipping"

fi 

mkdir /app
VALIDATE $? "Creating /app folder"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOG_FILE
VALIDATE $? "Download backend application code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? "Extracting backend application code" &>>LOG_FILE

npm install &>>LOG_FILE

cp /home/ec2-user/devops-classed-by-me/expense-shall/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>LOG_FILE
VALIDATE $? "Installing mysql"

mysql -h mysql.ramana3490.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "loading schema"

systemctl daemon-reload &>>LOG_FILE
VALIDATE $? "daemon-reload"

systemctl start backend &>>LOG_FILE
VALIDATE $? "Start backend"

systemctl enable backend &>>LOG_FILE
VALIDATE $? "Enabled backend"






