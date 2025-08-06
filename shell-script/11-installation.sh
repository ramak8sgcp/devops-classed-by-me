#!/bin/bash

USERID=$(id -u)
#echo "user ID is : $USERID"

if [ $USERID -ne 0 ]
then 
    echo "Please run this script with root priveleges"
    exit 1
fi
dnf list installed git
if [ $? -ne 0 ]
then 
    echo "Git is  not installed , going to install it"
    dnf install git -y
    if [ $? -ne 0 ]
    then 
        echo "Git installation is not success... Check it"
        exit 1
    else
        echo "Git installation is success"
    fi
else    
    echo "Git is already installed, nothing to do"
fi

# mysql installation
dnf list installed mysql
if [ $? -ne 0 ]
then 
    echo "mysql is  not installed , going to install it"
    dnf install mysql -y
    if [ $? -ne 0 ]
    then 
        echo "mysql installation is not success... Check it"
        exit 1
    else
        echo "mysql installation is success"
    fi
else    
    echo "mysql is already installed, nothing to do"
fi
