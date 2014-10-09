#!/bin/bash
localExecute <- function(){
	hdfs dfs -rm -R /user/starqiu/*Smpl/
	 hadoop jar SeperateSmpl.jar hdfs://localhost:9000/data/train/monitorData hdfs://localhost:9000/user/starqiu/posSmpl hdfs://localhost:9000/user/starqiu/negSmpl
	
}

remoteExecute<-function(){
	hdfs dfs -rm -R /user/team161/*Smpl/
	 hadoop jar SeperateSmpl.jar /data/train/monitorData /user/team161/posSmpl /user/team161/negSmpl
}
#hadoop jar SeperateSmpl.jar seperate.SeperateSamples hdfs://localhost:9000/data/train/monitorData hdfs://localhost:9000/user/starqiu/posSmpl hdfs://localhost:9000/user/starqiu/negSmpl

