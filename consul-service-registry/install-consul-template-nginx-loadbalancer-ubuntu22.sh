#!/bin/bash

# install consul
apt update
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt install consul -y
consul version

# install consul-template
wget https://releases.hashicorp.com/consul-template/0.31.0/consul-template_0.31.0_linux_amd64.zip
apt install zip unzip -y
unzip consul-template_0.31.0_linux_amd64.zip
mv consul-template /usr/local/bin/
consul-template --version
systemctl enable consul

# install & configure nginx
apt install -y nginx
systemctl enable nginx
echo 'upstream backend
{
{{- range service "nginx" }}
  server {{ .Address }}:{{ .Port }};
{{- end }}
}

server
{
        listen 80;
        server_name 192.168.7.72;

        location /
        {
                proxy_redirect off;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_pass http://backend;
        }
}' > load-balancer.conf.ctmpl

echo 'consul {
  address = "http://192.168.7.71:8500"
    retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}
template {
  source = "/root/load-balancer.conf.ctmpl"
  destination = "/etc/nginx/sites-enabled/load-balancer.conf"
  perms = 0600
  command = "systemctl reload nginx"
}' > /etc/consul.d/consul-template.hcl

consul-template -config=/etc/consul.d/consul-template.hcl &

