#!/bin/bash

apt update
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt install consul -y
consul version

mv /etc/consul.d/consul.hcl /etc/consul.d/consul.hcl-origin
echo 'datacenter = "dc1"
server = true
data_dir = "/var/lib/consul/"
bind_addr = "192.168.7.71"
client_addr = "192.168.7.71"
bootstrap = true
bootstrap_expect = 1

ui_config {
    enabled = true
}

enable_syslog = true
log_level = "INFO" ' > /etc/consul.d/consul.hcl

chown consul:consul /usr/bin/consul
chown --recursive consul:consul /etc/consul.d/
chown --recursive consul:consul /var/lib/consul
chmod 640 /etc/consul.d/consul.hcl-origin
chmod 640 /etc/consul.d/consul.hcl
systemctl enable consul
systemctl restart consul