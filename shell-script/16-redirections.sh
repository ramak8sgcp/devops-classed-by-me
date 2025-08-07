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

CHECK_ROOT

for package in $@
do
    dnf list installed $package | tee -a $LOG_FILE
    if [ $? -ne 0 ]
    then 
        echo "$package is  not installed , going to install it"
        dnf install $package -y
        VALIDATE $? "Installing $package"
    else    
        echo "$package is already installed, nothing to do"
    fi
done



# # mysql installation
# dnf list installed mysql
# if [ $? -ne 0 ]
# then 
#     echo "mysql is  not installed , going to install it"
#     dnf install mysql -y
#     VALIDATE $? "Installing MYSQL"
# else    
#     echo "mysql is already installed, nothing to do"
# fi



