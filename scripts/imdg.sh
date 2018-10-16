echo "Running imdg.sh"

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################
######################### Java ########################
#######################################################
echo "Installing Oracle Java 8 JDK..."
wget -O ~/jdk8.rpm -N --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm
yum -y localinstall ~/jdk8.rpm

#######################################################
################### Install Hazelcast #################
#######################################################
echo "Installing Hazelcast IMDG..."
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
