
#!/bin/bash
USRID=$(id -u)
R="\e[31m"
G="\e[32m"
B="\e[33m"
N="\e[0m"
PACKAGES=("mysql" "python3" "nginx" "httpd")


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
        echo -e "$G $2 installed successfully $N"
    else
        echo "installing $2 is failed"
        exit 1
    fi

}

for i in ${PACKAGES[@]}
do 

    dnf list installed $i 
    if [ $? -ne 0 ]
    then 
        echo "$i not installed..going to install"
        dnf install $i -y
        VALIDATE $? "$i"
    else 
        echo -e "$B already installed $N"
fi
done

