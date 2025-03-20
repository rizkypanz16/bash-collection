#!/bin/bash

# Install promtail => Promtail is an agent which ships the contents of local logs to a private Grafana Loki instance or Grafana Cloud

wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-amd64.zip
sudo apt install zip unzip -y
sudo unzip promtail-linux-amd64.zip
sudo chmod a+x promtail-linux-amd64
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
sudo mkdir -p /etc/promtail
sudo touch /tmp/positions.yaml
sudo touch /etc/promtail/promtail-local-config.yaml

sudo echo "server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://192.168.1.3:3100/loki/api/v1/push

scrape_configs:
- job_name: asset-inspection-cms-be
  static_configs:
  - targets:
      - localhost
    labels:
      hostname: "127.0.0.1"
      job: "auth-log"
      __path__: /var/log/auth.log
" | sudo tee /etc/promtail/promtail-local-config.yaml

sudo echo "[Unit]
Description=Promtail client for sending logs to Loki
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/promtail-local-config.yaml
Restart=always
TimeoutStopSec=3

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/promtail.service
sudo systemctl daemon-reload
sudo systemctl enable promtail
