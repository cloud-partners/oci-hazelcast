echo "Running imdg.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
################### Install Hazelcast #################
#######################################################
echo "Installing Hazelcast IMDG..."

yum -y install java

cd /opt
curl -O https://download.hazelcast.com/enterprise/hazelcast-enterprise-3.10.6.zip
unzip hazelcast-enterprise-3.10.6.zip
cd hazelcast-enterprise-3.10.6
cd bin

# This isn't going to work because there isn't a license.

# This is not a real solution:
nohup ./start.sh &
