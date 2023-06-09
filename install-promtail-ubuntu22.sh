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