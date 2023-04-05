#!/bin/bash

apt update
apt install mariadb-server -y
systemctl status mariadb
mysql_secure_installation