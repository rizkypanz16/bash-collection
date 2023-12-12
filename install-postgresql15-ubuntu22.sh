#!/bin/bash

# Create the file repository configuration:
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo mv /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/apt-postgresql.gpg

# Update the package lists:
sudo apt update

# Install the latest version of PostgreSQL.
sudo apt install postgresql-15

# Add listen addresses on postgresql.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/15/main/postgresql.conf
sudo cat /etc/postgresql/15/main/postgresql.conf | grep listen

# Add host authentication for 0.0.0.0/0
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/15/main/pg_hba.conf
sudo cat /etc/postgresql/15/main/pg_hba.conf | grep md5

sudo systemctl restart postgresql

