echo "Running imdg.sh"

echo "Got the parameters:"
echo version \'$version\'

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
echo "Installing Hazelcast..."

yum -y install maven

echo "
<dependency>
   <groupId>com.hazelcast</groupId>
   <artifactId>hazelcast-enterprise-all</artifactId>
   <version>${version}</version>
</dependency>
" > pom.xml



cd /opt
curl -O https://download.hazelcast.com/enterprise/hazelcast-enterprise-${version}.tar.gz
tar -xvf hazelcast-enterprise-${version}.tar.gz

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
