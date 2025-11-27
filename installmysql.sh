#/bin/bash
USRID=$(id -u)

if [ $USRID -ne 0 ]
then
     echo "ERROR:: please sign in with root user "
     exit 1
else 
    echo "already root user "
fi
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo " $2 installed successfully "
    else
        echo " installing $2 is failed "
        exit 1
    fi

}
dnf list installed mysql 

if [ $? -ne 0 ]
then 
    echo " msq not installed..going to install "
    dnf install mysql -y
    VALIDATE $? "mysql"
else 
    echo " already installed "
fi

dnf list installed python3

if [$? -ne 0]
then 
    echo " python3 is not installed..going to install "
    dnf install python3 -y
    VALIDATE $? " python3 "
else
    echo " python3 already installed "
fi

dnf list installed nginx

if[$? -ne 0]
then 
        echo " nginx is not installed ..going to install "
        dnf install nginx -y
        VALIDATE $? " nginx "
else 
        echo " nginx already installed "
fi