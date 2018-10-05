echo "Running node.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
################### Install Hazelcast #################
#######################################################
echo "Installing Hazelcast..."
curl -O https://download.hazelcast.com/enterprise/hazelcast-enterprise-${version}.zip
