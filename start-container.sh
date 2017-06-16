#!/bin/bash

# the default node number is 3 (1 master + 2 slaves)
#N=${1:-3}
N=${1:-5}


echo "start hadoop-master container..."
docker rm -f hadoop-master &> /dev/null #remove previous master
#TODO: add --rm for testing purposes (temporary container)
docker run -itd --net=hadoop -p 50070:50070 -p 8088:8088 --name hadoop-master --hostname hadoop-master hadoop-cluster 
# &> /dev/null #display output disabled

echo "---"

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	 docker rm -f hadoop-slave$i &> /dev/null
	 echo "start hadoop-slave$i container..."
	 docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
                	hadoop-cluster
#	                &> /dev/null # display output disabled
	i=$(( $i + 1 ))
done 

echo "get into master container"
# get into hadoop master container
docker exec -it hadoop-master bash
