#!/bin/bash
USRID=$(id -u)
R="/e[31m"
G="/e[32m"
B="/e[33m"
N="/e[0m"

if [ $USRID -ne 0 ]
then
    echo -e "$R ERROR:: please sign in with root user $n"
    exit 1
else 
    echo "already root user"
fi
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "$G $2 installed successfully $N"
    else
        echo "installing $2 is failed"
        exit 1
    fi

}
dnf list installed mysql 
if [ $? -ne 0 ]
then 
    echo "mysql not installed..going to install"
    dnf install mysql -y
    VALIDATE $? "mysql"
else 
    echo "$B already installed $N"
fi

dnf list installed python3
if [ $? -ne 0 ]
then 
    echo "python3 is not installed..going to install"
    dnf install python3 -y
    VALIDATE $? "python3"
else
    echo "$B python3 already installed $N"
fi

dnf list installed nginx
if [ $? -ne 0 ]

then 
    echo "nginx is not installed ..going to install"
    dnf install nginx -y
    VALIDATE $? "nginx"
else 
    echo "$B nginx already installed $N"
fi