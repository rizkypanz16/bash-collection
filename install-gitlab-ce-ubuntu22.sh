#!/bin/bash

curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
apt update && apt install gitlab-ce
sed -i "s-external_url 'http://gitlab.example.com'-external_url 'http://192.168.7.101'-" /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure
gitlab-ctl status
cat /etc/gitlab/initial_root_password