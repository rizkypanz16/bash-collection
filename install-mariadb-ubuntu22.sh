#!/bin/bash

apt update
apt install mariadb-server -y
systemctl status mariadb
sed -i 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
mysql_secure_installation
# enable root public access
# GRANT ALL PRIVILEGES ON *.* TO `root`@`%` IDENTIFIED BY 'ijinmasuk';
# FLUSH PRIVILEGES;
