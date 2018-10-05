echo "Running node.sh"

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
curl -O https://download.hazelcast.com/enterprise/hazelcast-enterprise-${version}.zip



#1. Ensure you have the appropriate Hazelcast jars (hazelcast-ee for Enterprise) installed. Normally
#hazelcast-all-<version>.jar is sufficient for all operations, but you may also install the smaller
#hazelcast-<version>.jar on member nodes and hazelcast-client-<version>.jar for clients.

#2. If not configured programmatically, Hazelcast IMDG looks for a hazelcast.xml configuration file for
#server operations and hazelcast-client.xml configuration file for client operations. Place all the
#configurations at their respective places so that they can be picked by their respective applications
#(Hazelcast server or an application client).

#3. Make sure that you have provided the IP addresses of a minimum of two Hazelcast server nodes and
#the IP address of the joining node itself, if there are more than two nodes in the cluster, in both the
#configurations. This is required to avoid new nodes failing to join the cluster if the IP address that was
#configured does not have any server instance running on it.
#Note: A Hazelcast member looks for a running cluster at the IP addresses provided in its configuration.
#For the upcoming member to join a cluster, it should be able to detect the running cluster on any of the IP
#addresses provided. The same applies to clients as well.

#4. Enable “smart” routing on clients. This is done to avoid a client sending all of its requests to the
#cluster routed through a Hazelcast IMDG member, hence bottlenecking that member. A smart client
#connects with all Hazelcast IMDG server instances and sends all of its requests directly to the respective
#member node. This improves the latency and throughput of Hazelcast IMDG data access.
#Further Reading: Hazelcast Blog: https://blog.hazelcast.com/whats-new-in-hazelcast-3/

#5. Make sure that all nodes are reachable by every other node in the cluster and are also accessible by clients
#(ports, network, etc).

#6. Start Hazelcast server instances first. This is not mandatory but a recommendation to avoid clients timing
#out or complaining that no Hazelcast server is found if clients are started before server.

#7. Enable/start a network log collecting utility. nmon is perhaps the most commonly used tool and is very easy
#to deploy.

#8. To add more server nodes to an already running cluster, start a server instance with a similar configuration
#to the other nodes with the possible addition of the IP address of the new node. A maintenance window is
#not required to add more nodes to an already running Hazelcast IMDG cluster.
