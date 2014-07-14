#!/bin/bash
# First script in setting up hduser for hadoop datanode slave
# This script should be run from slave host as root

# The following two lines are not needed if the user has been added through
# CentOS install
#adduser hduser
#passwd hduser

echo "####Add group and hduser to group####"
# add a group hadoopgroup
groupadd hadoopgroup
# add hduser to group
usermod -g hadoopgroup hduser

echo "####Update java packages####"
# update repositories to latest java. I found java-1.7.0_55 works well
# an older version of java that comes with CentOS does not have 'jps'
# command which is useful for hadoop status
yum update java-1.7.0-openjdk*

echo "####Installing newest java version####"
# install java
yum install java-1.7.0-openjdk*

echo "####Export Java Path####"
# set system variable for java and add to path
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/' >> /home/hduser/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME' >> /home/hduser/.bashrc

echo "####Downloading Hadoop####"
# download hadoop 2.2.0 from online apache source
wget http://download.nextag.com/apache/hadoop/common/hadoop-2.2.0/hadoop-2.2.0.tar.gz

echo "####Unzip and extract Hadoop####"
# extract hadoop package
tar xzvf hadoop-2.2.0.tar.gz

echo "####Move Hadoop to /usr/local/hadoop####"
# move hadoop to it's final location
mv hadoop-2.2.0 /usr/local/hadoop

# cleanup tar/zip file
rm hadoop-2.2.0.tar.gz

# set permission for hduser on hadoop path
chown -R hduser:hadoopgroup /usr/local/hadoop

# create tmp directories for namenode/datanode edits/ hadoop stuff
# I suppose datanodes will not need namenode folder...
mkdir -p /home/hduser/hadoopspace/hdfs/namenode
mkdir -p /home/hduser/hadoopspace/hdfs/datanode
chown -R hduser:hadoopgroup /home/hduser/hadoopspace

echo "####Export hadoop sys variables to .bashrc####"

echo 'export HADOOP_INSTALL=/usr/local/hadoop' >> /home/hduser/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_INSTALL' >> /home/hduser/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_INSTALL' >> /home/hduser/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_INSTALL' >> /home/hduser/.bashrc
echo 'export YARN_HOME=$HADOOP_INSTALL' >> /home/hduser/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native' >> /home/hduser/.bashrc
echo 'export PATH=$PATH:$HADOOP_INSTALL/sbin' >> /home/hduser/.bashrc
echo 'export PATH=$PATH:$HADOOP_INSTALL/bin' >> /home/hduser/.bashrc

echo "####Replace java path for hadoop####"
#set variables for hadoop/etc/hadoop-env.sh
sed 's/export JAVA_HOME=.*/export JAVA_HOME=\/usr\/lib\/jvm\/jre\-1\.7\.0\-openjdk\.x86_64\//g' /usr/local/hadoop/etc/hadoop/hadoop-env.sh > /usr/local/hadoop/etc/hadoop/hadoop-env.sh.copy

mv /usr/local/hadoop/etc/hadoop/hadoop-env.sh.copy /usr/local/hadoop/etc/hadoop-env.sh

echo "####Copying Hadoop Configuration files####"
# copy config files
# not sure if I can do this here or have to wait to complete
# ssh hand shaking. Should have a general and maintained 
# location to copy config files from
scp ncp-eg6:/usr/local/hadoop/etc/hadoop/* /usr/local/hadoop/etc/hadoop/

echo "####Copying sshd_config file####"
# copy ssh_config file as well????
scp ncp-eg6:/etc/ssh/sshd_config /etc/ssh/sshd_config
