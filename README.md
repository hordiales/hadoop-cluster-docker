Nota: Fork del proyecto [kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker) adaptado para usar la imagen de base recomendada por la [documentación de Hadoop](https://hadoop.apache.org/docs/stable2/hadoop-yarn/hadoop-yarn-site/DockerContainerExecutor.html): [sequenceiq/hadoop-docker](https://github.com/sequenceiq/hadoop-docker) (soporta diferentes versiones)

Modo: Master/slave (no es autodiscovrery)

# Cluster Hadoop de 4 nodos (1 master y 3 slaves) usando Docker

## Configuración inicial
##### 1. Crear una docker red hadoop
```
$ docker network create --driver=bridge hadoop
```

![hadoop master slave diagram](https://raw.githubusercontent.com/kiwenlau/hadoop-cluster-docker/master/hadoop-cluster-docker.png)

#### 2. Construir la imagen docker
```
$ ./build-image.sh
```

Parte de la imagen base mencionada y configura ssh, los nodos esclavos, la configuración general, etc.

## Uso

##### Lanzar los containers (master y los esclavos)
```
$ ./start-container.sh
```

Crea el container master y los slaves con configuraciones diferentes, usando la misma red. Cuando inicia el master, bindea el puerto 50070 y el 8088 con el host.

Abre un bash en el master.

TIP: agregar --rm para que los containers sean temporarios.

En caso de agregar más nodos, actualizar el archivo config/slaves

##### Iniciar hadoop en el master
(desde el bash del master)
```
$ ./start-hadoop.sh
```

Para monitorear, con el browser conectarse a: [http://localhost:50070](http://localhost:50070)

## Pruebas/Ejemplos

Paper original sobre Map Reduce (Google) [Simplified Data Processing on Large Clusters](https://static.googleusercontent.com/media/research.google.com/es//archive/mapreduce-osdi04.pdf)

## Ejemplo default de la documentación oficial (WordCount)

Dado un input, cuenta el número de ocurrencias para cada palabra.

```
$ VERSION=2.7.0
$ cd /usr/local/hadoop-$VERSION
$ bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-$VERSION.jar grep input output 'dfs[a-z.]+'
```
(o correr ~/run-wordcount.sh)

Referencia: https://hadoop.apache.org/docs/r2.8.0/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html#Example:_WordCount_v1.0

### Copiar a localhost y ver el resultado
```
$ bin/hdfs dfs -get output output
$ cat output/*
```

### O mirar directamente el resultado en el filesystem distribuido (DFS)
```
$ bin/hdfs dfs -cat output/*
```

## wordcount example

```
$ ./run-wordcount.sh
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

### Output log
![Output log](mapreduce-example.png)

<!--### Arbitrary size Hadoop cluster

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

do 5~6 like section A-->

NOTA: Testeado con Hadoop versión 2.7.0. En caso de que la imagen docker cambie de versión, será necesario actualizar varios scritps. Buscar donde con 'fgrep 2.7.0 -R .'
