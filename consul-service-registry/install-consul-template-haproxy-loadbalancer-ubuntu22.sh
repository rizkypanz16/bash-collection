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

# install & configure haproxy
apt install -y haproxy
systemctl enable haproxy
echo 'global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

frontend panzconsul2
        bind 192.168.7.72:80
        default_backend panzconsul-backend

backend panzconsul-backend
        {{ range service "nginx" }}
        server {{ .Node }} {{ .Address }}:{{ .Port }}
        {{ end }}' > /root/haproxy.cfg.ctmpl
		
echo 'consul {
  address = "http://192.168.7.71:8500"
    retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}
template {
  source = "/root/haproxy.cfg.ctmpl"
  destination = "/etc/haproxy/haproxy.cfg"
  command = "systemctl reload haproxy"
}' > /etc/consul.d/consul-template.hcl

consul-template -config=/etc/consul.d/haproxy-consul.hcl &
