echo "Running mancenter.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
############### Install Management Center #############
#######################################################
echo "Installing Hazelcast Management Center..."

yum -y install java

cd /opt
curl -O https://download.hazelcast.com/management-center/hazelcast-management-center-3.10.3.zip
unzip hazelcast-management-center-3.10.3.zip
cd hazelcast-management-center-3.10.3
chmod +x start.sh

# This is not a real solution:
nohup ./start.sh &
