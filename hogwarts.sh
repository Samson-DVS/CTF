#!/bin/bash

# Create a user named 'potter' with the passowrd 'Expelliarmus'
adduser potter
echo "potter:Expelliarmus" | chpasswd

# Create a text file for the user potter in home directory with the given text
echo "hello potter, let's face you know who at ministry of magic, but you must remeber I'm the sudo, and find my spell" > /home/potter/message.txt

# Create a sudo user with limited named 'dumbledore' with the password 'Firestorm'
adduser dumbledore
echo "dumbledore:Firestorm" | chpasswd
usermod -aG sudo dumbledore

# Change the default SSH port to 3478, and allow sudo user to login
sed -i 's/#Port 22/Port 3478/' /etc/ssh/sshd_config
echo "AllowUsers dumbledore" >> /etc/ssh/sshd_config
systemctl restart ssh

# Limit the SSH login if failed more than 10 times
echo "MaxAuthTries 10" >> /etc/ssh/sshd_config
systemctl restart ssh
