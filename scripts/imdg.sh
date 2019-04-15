#!/bin/bash

echo "Running imdg.sh"

# Configure firewall
firewall-offline-cmd --add-port=5701/tcp
systemctl restart firewalld

# Install Hazelcast IMDG
echo "Installing Hazelcast IMDG..."

yum -y install java

cd /opt
curl -L -o hazelcast-3.12.zip https://download.hazelcast.com/download.jsp\?version\=hazelcast-3.12\&p\=446539331
unzip hazelcast-3.12.zip
cd hazelcast-3.12
cd bin

nohup ./start.sh &
