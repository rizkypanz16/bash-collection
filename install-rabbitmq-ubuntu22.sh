#!/bin/bash

# Step 1: Install Erlang
# RabbitMQ requires Erlang to be installed first before it can run
sudo apt update
sudo apt install curl software-properties-common apt-transport-https lsb-release
curl -1sLf 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/setup.deb.sh' | sudo -E bash
sudo apt update && sudo apt install erlang

# Step 2: Add RabbitMQ Repository to Ubuntu. Rabbitmq listening on TCP port 5672
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
sudo apt update && sudo apt install rabbitmq-server

# Step 3: Enable RabbitMQ Dashboard (Optional). The Web service should be listening on TCP port 15672
sudo rabbitmq-plugins enable rabbitmq_management

# To be able to login on the network, create an admin user like below:
sudo rabbitmqctl add_user admin Pass!#2023
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

# List available Virtualhosts:
rabbitmqctl list_vhosts
