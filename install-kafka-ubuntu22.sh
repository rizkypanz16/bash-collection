#!/bin/bash

sudo apt update
sudo apt install default-jdk
java -version
wget https://archive.apache.org/dist/kafka/3.5.0/kafka_2.12-3.5.0.tgz
tar xvf kafka_2.12-3.5.0.tgz
sudo mv kafka_2.12-3.5.0 /usr/local/kafka

echo "[Unit]
Description=Apache Zookeeper server
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
ExecStart=/usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
ExecStop=/usr/local/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/zookeeper.service

echo '[Unit]
Description=Apache Kafka Server
Documentation=http://kafka.apache.org/documentation.html
Requires=zookeeper.service

[Service]
Type=simple
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
ExecStart=/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties
ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/kafka.service

sudo sed -i 's/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/' /usr/local/kafka/config/server.properties
sudo sed -i 's/#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092/advertised.listeners=PLAINTEXT:\/\/192.168.1.189:9092/' /usr/local/kafka/config/server.properties
sudo systemctl daemon-reload && sudo systemctl enable kafka zookeeper
sudo systemctl daemon-reload && sudo systemctl enable kafka zookeeper
/usr/local/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic testTopic
