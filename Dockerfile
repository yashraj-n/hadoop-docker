# Dockerfile
FROM openjdk:11

ENV HADOOP_VERSION 3.3.6
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN apt-get update && \
    apt-get install -y ssh rsync curl && \
    curl -O https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

# Setup SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN echo "export JAVA_HOME=/usr/local/openjdk-11" >> $HADOOP_CONF_DIR/hadoop-env.sh

COPY core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml $HADOOP_CONF_DIR/

COPY start-hadoop.sh /start-hadoop.sh
RUN chmod +x /start-hadoop.sh

RUN hdfs namenode -format -force

EXPOSE 9000 9870 8088 8042 19888

CMD ["/start-hadoop.sh"]


