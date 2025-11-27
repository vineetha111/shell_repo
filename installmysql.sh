#/bin/bash
USRID=$(id -u)

if [ $USRID -ne 0 ]
then
 
    echo "ERROR:: please sign in with root user "
    exit 1
else 
    echo "already root user "
fi

dnf list installed mysql 

if [ $? -ne 0]
then 
     echo " msq not installed..going to install "
    dnf install mysql -y
    if [$? -eq 0]
    then
        echo " mysql installed successfully "
    else
        echo " installing mysql is failed "
        exit 1
    fi
else 
    echo " already installed "
fi