#!/bin/bash

apt update
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt install consul -y
consul version
apt install nginx -y
systemctl enable nginx && systemctl start nginx
mkdir -p /var/lib/consul/
chown consul:consul /usr/bin/consul
chown --recursive consul:consul /etc/consul.d/
chown --recursive consul:consul /var/lib/consul
echo '{
  "datacenter": "dc1",
  "data_dir": "/var/lib/consul/",
  "log_level": "INFO",
  "service": {
    "name": "nginx",
    "tags": ["web"],
    "port": 80,
    "check": {
      "http": "http://localhost:80/",
      "interval": "10s"
    }
  },
  "bind_addr": "192.168.7.74",
  "retry_join": ["192.168.7.71"]
}' > /etc/consul.d/nginx.json
chmod 640 /etc/consul.d/nginx.json
systemctl enable consul && systemctl start consul
consul agent -config-file=/etc/consul.d/nginx.json &
