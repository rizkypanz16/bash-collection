#!/bin/bash

apt update
apt install -y curl openssh-server ca-certificates tzdata perl
apt install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL="http://192.168.7.101" apt-get install gitlab-ee
echo "Installation Success !"
echo ""
echo "gitlab initial password : "
cat /etc/gitlab/initial_root_password