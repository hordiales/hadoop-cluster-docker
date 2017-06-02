VERSION=2.7.0
cd /usr/local/hadoop-$VERSION
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-$VERSION.jar grep input output 'dfs[a-z.]+'

