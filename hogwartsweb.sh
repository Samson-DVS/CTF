#!/bin/bash

#Update the package manager
sudo apt-get update

#Install Apache web server, PHP, and MySQL
sudo apt-get install apache2 php mysql-server

#Enable mod_rewrite for Apache
sudo a2enmod rewrite

#Create a new virtual host for the PHP application
echo '<VirtualHost *:80>
ServerName hogwarts
DocumentRoot /var/www/html/hogwarts
<Directory /var/www/html/hogwarts>
AllowOverride All
</Directory>
</VirtualHost>' | sudo tee /etc/apache2/sites-available/hogwarts.conf

#Enable the virtual host
sudo a2ensite hogwarts

#Restart Apache to apply the changes
sudo service apache2 restart

#Create the specified subdirectories
mkdir -p hogwarts/avadakedavra hogwarts/gingerbeer hogwarts/roomofrequirements

#Create the text file in the avadakedavra directory
echo 'sorry, now defend AVADAKEDAVARA' > hogwarts/avadakedavra/port_key

#Create the text file in the gingerbeer directory
echo 'sorry, it's a rabbit hole' > hogwarts/gingerbeer/port_key

#Create the text file in the roomofrequirements directory
echo 'key:alohomora' > hogwarts/roomofrequirements/port_key

#Set the correct permissions for the hogwarts files
sudo chown -R www-data:www-data hogwarts
sudo chmod -R 755 hogwarts

#Create a MySQL database and user for the PHP application
mysql -u root -p
CREATE DATABASE hogwarts;
GRANT ALL PRIVILEGES ON hogwarts.* TO 'hogwarts_user'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
