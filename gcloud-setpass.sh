#!/bin/bash
if [ $# -lt 2 ]
then
        echo "we need two parameters: username and password"
        exit
fi
echo "enabling Password Login"
sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo "reloading sshd"
sudo /etc/init.d/ssh reload
echo "adding user '$1'"
sudo adduser $1 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "setting user password to: $2"
echo "$1:$2" | sudo chpasswd

echo "adding user to sudo group"
sudo usermod -G adm,sudo,$1 $1
