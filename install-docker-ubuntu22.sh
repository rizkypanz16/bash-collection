#!/bin/bash

sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install docker-ce -y
sudo systemctl status docker