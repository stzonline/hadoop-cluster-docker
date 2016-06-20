#!/bin/bash

# the default node number is 3
#N=${1:-3}
N=${1:-2}




# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
					-v /home/update/hadoop-cluster-docker/config:/config \
	                hadoop_spark_cluster:0.2.0  /bin/sh -c "/config/slave.sh;tail -f /config/slave.sh"
	i=$(( $i + 1 ))
done 

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                -v /home/update/hadoop-cluster-docker/config:/config \
                hadoop_spark_cluster:0.2.0  /bin/sh -c "/config/start.sh;tail -f /config/start.sh"

# get into hadoop master container
sudo docker exec -it hadoop-master bash
