#!/bin/bash

# Set environment variables explicitly
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME=/usr/local/openjdk-11

# Make sure binaries are executable
chmod +x $HADOOP_HOME/bin/*
chmod +x $HADOOP_HOME/sbin/*

# Start SSH
service ssh start

echo "Starting NameNode..."
$HADOOP_HOME/bin/hdfs --daemon start namenode

echo "Starting DataNode..."
$HADOOP_HOME/bin/hdfs --daemon start datanode

echo "Starting SecondaryNameNode..."
$HADOOP_HOME/bin/hdfs --daemon start secondarynamenode

echo "Starting ResourceManager..."
$HADOOP_HOME/bin/yarn --daemon start resourcemanager

echo "Starting NodeManager..."
$HADOOP_HOME/bin/yarn --daemon start nodemanager

echo "Current Java processes:"
jps

echo "Hadoop started"

# Keep container running
tail -f /dev/null