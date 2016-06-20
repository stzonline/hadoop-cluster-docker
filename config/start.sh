#!/bin/bash

echo ".................................."
source /etc/profile
echo $JAVA_HOME

service sshd start

echo "172.17.0.3 master" >> /etc/hosts
echo "172.17.0.2 slave1" >> /etc/hosts

/home/hadoop/hadoop-2.6.2/sbin/start-dfs.sh
/home/hadoop/hadoop-2.6.2/sbin/start-yarn.sh

/home/spark/spark-1.3.1-bin-hadoop2.6/sbin/start-all.sh

jps

tail -10f /home/hadoop/hadoop-2.6.2/etc/hadoop/start.sh
#tail -100f /opt/hadoop-1.2.1/conf/end.txt
