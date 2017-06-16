VERSION=2.7.0
cd /usr/local/hadoop-$VERSION
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-$VERSION.jar grep input output2 'dfs[a-z.]+'
bin/hdfs dfs -cat output2/*

