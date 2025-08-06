#!/bin/bash

USERID=$(id -u)
#echo "user ID is : $USERID"

if [ $USERID -ne 0 ]
then 
    echo "Please run this script with root priveleges"
    exit 1
fi
dnf list installed git

