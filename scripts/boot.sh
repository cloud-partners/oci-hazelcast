#!/bin/bash
## cloud-init bootstrap script

set -x 

THIS_FQDN=`hostname --fqdn`
THIS_HOST=$${THIS_FQDN%%.*}



do_curl_retrieval() {
        SRC_URL=$${1%/}
        #curl -f -s $SRC_URL/$LFILE -o $TARGET_DIR/$LFILE \
                --retry $MAX_RETRIES --retry-max-time 60
        #[ $? -ne 0 ] && return 1
        local rval=0
        for f in $(cat $TARGET_DIR/$LFILE) ; do
                [ -z "$f" ] && continue
                curl -f -s $SRC_URL/$f -o $TARGET_DIR/$f \
                        --retry $MAX_RETRIES --retry-max-time 180
                [ $? -ne 0 ] && rval=1
                chmod a+x $TARGET_DIR/$f
        done
        return $rval
}



MIN_HEAP_SIZE=$1
MAX_HEAP_SIZE=$2
sudo apt-get update -y
sudo apt-get install default-jdk -y
sudo apt-get install maven2 -y
sudo mvn install

TARGET_DIR=/home/ubuntu
LFILE="scripts.lst"
cd $TARGET_DIR

cat > $LFILE << EOF_scripts_lst
bootstrap_hazelcast
hazelcast-server.conf
hazelcast.xml
install_hazelcast
logging.properties
modify_configuration
pom.xml
EOF_scripts_lst

TARGET_DIR=/home/ubuntu
SCRIPT_SRC="https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/hazelcast-vm-cluster/"
MAX_RETRIES=10
do_curl_retrieval $SCRIPT_SRC
if [ $? -ne 0 ] ; then
     echo "do_curl_retrieval failed"
fi



#### minimum heap size
if [ "x$MIN_HEAP_SIZE" = "x" ]
 then
   MIN_HEAP_SIZE=4G
fi
if [ "x$MAX_HEAP_SIZE" = "x" ]
 then
  MAX_HEAP_SIZE=4G
fi

if [ "x$MIN_HEAP_SIZE" != "x" ]; then
  JAVA_OPTS="$JAVA_OPTS -Xms${MIN_HEAP_SIZE}"
fi
if [ "x$MAX_HEAP_SIZE" != "x" ]; then
  JAVA_OPTS="$JAVA_OPTS -Xms${MAX_HEAP_SIZE}"
fi
# persist this variable to the VM environment
sudo sh -c 'echo "JAVA_OPTIONS=$JAVA_OPTS" >> /etc/environment'

# create the hazelcast home directory
sudo mkdir /var/hazelcast
sudo cp pom.xml /var/hazelcast
sudo cp ./hazelcast.xml /var/hazelcast/



echo ${ClusterName} > /tmp/clustername
echo ${MemberNodeCount} > /tmp/membernodecount




echo "boot.sh.tpl setup complete"

set +x 
 
