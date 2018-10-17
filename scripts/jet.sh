echo "Running jet.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
###################### Install Jet ####################
#######################################################
echo "Installing Hazelcast Jet..."

yum -y install java

cd /opt
curl -O https://download.hazelcast.com/jet-enterprise/hazelcast-jet-enterprise-0.7.zip
unzip hazelcast-jet-enterprise-0.7.zip
cd hazelcast-jet-enterprise-0.7
cd bin

# This isn't going to work because there isn't a license.

# This is not a real solution:
nohup ./jet-start.sh &
