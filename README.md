Fork de [https://github.com/kiwenlau/hadoop-cluster-docker]
pero usando como imagen de base la recomendada por hadoop: sequenceiq/hadoop-docker ([https://hadoop.apache.org/docs/stable2/hadoop-yarn/hadoop-yarn-site/DockerContainerExecutor.html])

![alt tag](https://raw.githubusercontent.com/kiwenlau/hadoop-cluster-docker/master/hadoop-cluster-docker.png)

### Cluster Hadoop de 4 nodos usando Docker

##### 1. Crear una docker red hadoop
```
sudo docker network create --driver=bridge hadoop
```

#### 2. Construir la imagen docker
```
$ ./build-image.sh
```

Parte de la imagen base mencionada y configura ssh, los nodos esclavos, la configuración general, etc.

##### 3. Lanzar los containers (master y los esclavos)
```
./start-container.sh
./
```

Crea el container master y los slaves con configuraciones diferentes, usando la misma red.

##### 4. Iniciar hadoop en el master

```
./start-hadoop.sh
```

### Pruebas


#### run wordcount

```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

### Arbitrary size Hadoop cluster

##### 1. pull docker images and clone github repository

do 1~3 like section A

##### 2. rebuild docker image

```
sudo ./resize-cluster.sh 5
```
- specify parameter > 1: 2, 3..
- this script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes


##### 3. start container

```
sudo ./start-container.sh 5
```
- use the same parameter as the step 2

##### 4. run hadoop cluster 

do 5~6 like section A

