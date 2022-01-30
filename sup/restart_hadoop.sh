#!/bin/bash
# Seems lame that every time you reboot, hdfs needs this kind of help.
# Maybe need to sbin/stop-all.sh before reboot.
hh2
bin/hdfs namenode -format
sbin/start-dfs.sh
jps
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/jay
sbin/start-yarn.sh
jps
bin/hdfs dfs -copyFromLocal etc/hadoop/core-site.xml .
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.5.jar grep ./core-site.xml output 'configuration'

# Sometimes, jps will not show namenode,secondarynamenode,datanode running, but
#   ps aux | grep Dhadoop | gv grep 
# will show them.  If you kill them with
#   kill -15 `ps aux | grep Dhadoop | gv grep | awk '{print $2}'`
# then jps will show the namenode did not start and the log
#   logs/hadoop-jay-namenode-Jays-MacBook-Pro.local.log
# will say 
#   Exception: There appears to be a gap in the edit log.
# The cure is:
#   bin/hadoop namenode -recover 

# Is HADOOP_CLASSPATH necessary?
#HADOOP_CLASSPATH=share/hadoop/yarn/test/hadoop-yarn-server-tests-3.0.0-tests.jar bin/hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-3.0.0-tests.jar minicluster 
