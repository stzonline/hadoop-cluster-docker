##Run Hadoop Custer within Docker Containers


###3 Nodes Hadoop Cluster

#####1. pull docker image
```
#wget http://download.openvz.org/template/precreated/ubuntu-14.04-x86_64.tar.gz
#cat ubuntu-14.04-x86_64.tar.gz |docker import - ubuntu:base
#docker run -it ubuntu:base /bin/bash

#apt-get update
#apt-get upgrade
#apt-get install -y gcc make python-dev python-setuptools git 
#apt-get install -f libnuma1 numactl
#exit
#docker ps -a //查看CONTAINER ID
#docker commit CONTAINERID ubuntu:latest
```
#####2. clone github repository

```
git clone https://github.com/stzonline/hadoop-cluster-docker

创建jdk目录并下载 jdk-8u91-linux-x64.tar.gz到jdk文件下

docker build -t="hadoop_spark_cluster:0.1.0" .
```

#####3. create hadoop network

```
sudo docker network create --driver=bridge hadoop
```

#####4. start container
cd hadoop-cluster-docker
sudo ./start-container.sh

