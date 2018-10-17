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

#####

rallyDNS="couchbase-server.hazelcast.hazelcast.oraclevcn.com"
nodeDNS=$(hostname)
nodeDNS+=".hazelcast.hazelcast.oraclevcn.com"

echo "Using the settings:"
echo rallyDNS \'$rallyDNS\'
echo nodeDNS \'$nodeDNS\'

if [[ $rallyDNS == $nodeDNS ]]
then
  echo "I'm the rally point."
else
  echo "I'm just a regular node."
fi
