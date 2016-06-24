#!/bin/bash

#echo ".................................."
#source /etc/profile
#echo $JAVA_HOME

#service sshd start
service ssh start

#echo "172.17.0.3 master" >> /etc/hosts
#echo "172.17.0.2 slave1" >> /etc/hosts

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

$SPARK_HOME/sbin/start-all.sh

jps

#tail -10f /home/hadoop/hadoop-2.6.2/etc/hadoop/start.sh
#tail -100f /opt/hadoop-1.2.1/conf/end.txt
