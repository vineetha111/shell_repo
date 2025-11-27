#!/bin/bash
USRID=$(id -u)
R="\e[31m"
G="\e[32m"
B="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started executing at : $(date)" &>>$LOG_FILE

if [ $USRID -ne 0 ]
then
    echo -e "$R ERROR:: please sign in with root user $n" &>>$LOG_FILE
    exit 1
else 
    echo "already root user" &>>$LOG_FILE
fi
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$G $2 installed successfully $N" &>>$LOG_FILE
    else
        echo "installing $2 is failed" &>>$LOG_FILE
        exit 1
    fi

}
dnf list installed mysql &>>$LOG_FILE
if [ $? -ne 0 ]
then 
    echo "mysql not installed..going to install" &>>$LOG_FILE
    dnf install mysql -y &>>$LOG_FILE
    VALIDATE $? "mysql"
else 
    echo -e "$B already installed $N" &>>$LOG_FILE
fi

dnf list installed python3 &>>$LOG_FILE
if [ $? -ne 0 ]
then 
    echo -e "python3 is not installed..going to install"
    dnf install python3 -y &>>$LOG_FILE
    VALIDATE $? "python3"
else
    echo -e "$B python3 already installed $N"
fi

dnf list installed nginx &>>$LOG_FILE
if [ $? -ne 0 ]

then 
    echo "nginx is not installed ..going to install" &>>$LOG_FILE
    dnf install nginx -y &>>$LOG_FILE
    VALIDATE $? "nginx"
else 
    echo -e "$B nginx already installed $N" &>>$LOG_FILE
fi