#!/bin/bash
noExecute <- function(){
	hdfs dfs -rm -R /user/starqiu/posSmpl/
	
}
#hadoop jar SeperateSmpl.jar seperate.SeperateSamples hdfs://localhost:9000/data/train/monitorData hdfs://localhost:9000/user/starqiu/posSmpl hdfs://localhost:9000/user/starqiu/negSmpl

 hadoop jar SeperateSmpl.jar hdfs://localhost:9000/data/train/monitorData hdfs://localhost:9000/user/starqiu/posSmpl hdfs://localhost:9000/user/starqiu/negSmpl
