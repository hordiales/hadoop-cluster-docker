# With hadoop 2.7.0
FROM sequenceiq/hadoop-docker

WORKDIR /root

# set environment variable
ENV JAVA_HOME=/usr/java/default
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
RUN rm /root/.ssh/*
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN echo "StrictHostKeyChecking no" > ~/.ssh/config

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode 

COPY config/* /tmp/

RUN    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
	mv /tmp/sshd_config /etc/ssh/sshd_config  && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/*.sh ~/
	
RUN chmod +x ~/*.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c",  "bash service sshd start; bash"]

