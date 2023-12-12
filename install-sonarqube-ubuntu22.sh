#!/bin/bash

# before install sonarqube install java & postgresql
# set postgres_db=sonarqube postgres_user=sonar postgres_password=sonar123

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.1.0.73491.zip
unzip sonarqube-10.1.0.73491.zip
sudo mv sonarqube-10.1.0.73491 /opt/sonarqube
sudo groupadd sonar
sudo useradd -d /opt/sonarqube -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube -R

echo "vm.max_map_count=524288
fs.file-max=131072" | sudo tee -a /etc/sysctl.conf
sudo sysctl --system

ulimit -n 131072
ulimit -u 8192

sudo sed -i 's/#sonar.jdbc.username=/sonar.jdbc.username=sonar/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.jdbc.password=/sonar.jdbc.password=sonar123/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.jdbc.url=jdbc:postgresql:\/\/localhost\/sonarqube?currentSchema=my_schema/sonar.jdbc.url=jdbc:postgresql:\/\/localhost:5432\/sonarqube/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.web.host=0.0.0.0/sonar.web.host=0.0.0.0/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.web.port=9000/sonar.web.port=9000/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.web.javaAdditionalOpts=/sonar.web.javaAdditionalOpts=-server/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.web.javaOpts=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError/sonar.web.javaOpts=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError/' /opt/sonarqube/conf/sonar.properties

echo "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always


LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/sonar.service

sudo systemctl daemon-reload
sudo systemctl start sonar.service
sudo systemctl enable sonar.service

# sonar_default_user=admin
# sonar_default_password=admin