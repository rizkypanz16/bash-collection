#!/bin/bash

# before install ansible create ssh-keygen & ssh-copy-id root@localhost

sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo ansible --version
sudo wget https://raw.githubusercontent.com/ansible/ansible/stable-2.9/examples/ansible.cfg -O /etc/ansible/ansible.cfg

sudo sed -i 's.#inventory      = /etc/ansible/hosts.inventory      = /etc/ansible/hosts.' /etc/ansible/ansible.cfg
sudo sed -i 's.#host_key_checking = False.host_key_checking = False.' /etc/ansible/ansible.cfg
sudo sed -i 's.#remote_user = root.remote_user = root.' /etc/ansible/ansible.cfg

sudo sed -i 's.#become=True.become=True.' /etc/ansible/ansible.cfg
sudo sed -i 's.#become_method=sudo.become_method=sudo.' /etc/ansible/ansible.cfg
sudo sed -i 's.#become_user=root.become_user=root.' /etc/ansible/ansible.cfg
sudo sed -i 's.#become_ask_pass=False.become_ask_pass=False.' /etc/ansible/ansible.cfg

sudo mv /etc/ansible/hosts /etc/ansible/hosts-default
sudo bash -c 'cat << EOF > /etc/ansible/hosts
[local]
# localhost
# ansible_user=ubuntu ansible_host=192.168.1.3 ansible_become=true
EOF'
ansible --version
#ansible -m ping all
