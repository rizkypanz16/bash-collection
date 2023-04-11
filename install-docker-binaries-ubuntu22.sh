#!/bin/bash
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/containerd.io_1.6.9-1_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-ce_23.0.3-1~ubuntu.22.04~jammy_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-ce-cli_23.0.3-1~ubuntu.22.04~jammy_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-buildx-plugin_0.10.4-1~ubuntu.22.04~jammy_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-compose-plugin_2.6.0~ubuntu-jammy_amd64.deb
dpkg -i ./containerd.io_1.6.9-1_amd64.deb \
./docker-buildx-plugin_0.10.4-1~ubuntu.22.04~jammy_amd64.deb \
./docker-ce-cli_23.0.3-1~ubuntu.22.04~jammy_amd64.deb \
./docker-ce_23.0.3-1~ubuntu.22.04~jammy_amd64.deb \
./docker-compose-plugin_2.6.0~ubuntu-jammy_amd64.deb
docker --version
