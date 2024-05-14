#!/bin/bash

sudo apt install lsb-release curl gpg
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt update
sudo apt install -y redis
sudo systemctl status redis-server.service | grep Active:
sudo sed -i 's/bind 127.0.0.1 -::1/bind 0.0.0.0/' /etc/redis/redis.conf
sudo cat /etc/redis/redis.conf | grep "bind "
sudo systemctl restart redis-server.service
sudo sed -i 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf
sudo cat /etc/redis/redis.conf | grep protected-mode
sudo sed -i 's/# requirepass foobared/requirepass ijinmasuk/' /etc/redis/redis.conf
sudo cat /etc/redis/redis.conf | grep requirepass
sudo systemctl restart redis-server.service
