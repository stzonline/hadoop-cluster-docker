FROM ubuntu:latest

MAINTAINER Shentz <stzonlive@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
#RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget
RUN apt-get update && apt-get install -y openssh-server wget
RUN apt-get install -y openssh-server && apt-get install -y openssh-client

# install hadoop 2.6.2
RUN wget http://ftp.riken.jp/net/apache/hadoop/common/hadoop-2.6.2/hadoop-2.6.2.tar.gz && \
	rm -rf /usr/local/hadoop  && \
    tar -xzvf hadoop-2.6.2.tar.gz && \
    mv hadoop-2.6.2 /usr/local/hadoop && \
    rm hadoop-2.6.2.tar.gz
	
RUN wget http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz && \
	rm -rf /usr/lib/scala  && \
	mkdir -p /usr/lib/scala && \
    tar -xzvf scala-2.11.8.tgz -C /usr/lib/scala && \
    rm scala-2.11.8.tgz
	
RUN wget http://archive.apache.org/dist/spark/spark-1.3.1/spark-1.3.1-bin-hadoop2.6.tgz && \
	rm -rf /usr/local/spark  && \
    tar -xzvf spark-1.3.1-bin-hadoop2.6.tgz && \
    mv spark-1.3.1-bin-hadoop2.6 /usr/local/spark && \
    rm spark-1.3.1-bin-hadoop2.6.tgz

COPY config/* /tmp/
COPY jdk/* /tmp/

RUN chmod 777 /tmp/*

RUN mkdir -p /usr/lib/jvm
RUN tar zxvf /tmp/jdk-8u91-linux-x64.tar.gz -C /usr/lib/jvm	
	
	
# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_91
ENV JRE_HOME=${JAVA_HOME}/jre
ENV HADOOP_HOME=/usr/local/hadoop
ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV SCALA_HOME=/usr/lib/scala/scala-2.11.8
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:${JAVA_HOME}/bin:$HADOOP_HOME/bin:$SCALA_HOME/bin:$SPARK_HOME/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs



RUN cp /tmp/ssh_config ~/.ssh/config && \
	cp /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
	cp /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
	cp /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
	cp /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
	cp /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
	cp /tmp/yarn-env.sh /usr/local/hadoop/etc/hadoop/yarn-env.sh && \
	cp /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    cp /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
	cp /tmp/slaves $SPARK_HOME/conf/slaves



# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

