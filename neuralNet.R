library(ROCR)
library(nnet)

init.simple.env <- function(){
#   BASE.PATH <<- "/home/xqiu/kdd/data/"
#   SAVE.BASE.PATH <<- "/home/xqiu/kdd/data/combineModel/"
  BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/"
  SAVE.BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/combineModel/"
}

init.env <-function(){
  BASE.PATH <<- "/home/xqiu/kdd/data/"
  SAVE.BASE.PATH <<- "/home/xqiu/kdd/data/combineModel/"
  train.feature <<- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
  test.feature <<- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",") 

#   BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/"
#   test.feature <<- read.table(paste(BASE.PATH,"tef",sep=""),sep=",")
#   train.feature <<- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
  # num <<- nrow(train.feature)
  
  REMOVE.FEATRUE.INDEX <<-c(5,28)
  CLASS.INDEX <<-  ncol(train.feature)
  train.col <<- colnames(train.feature,prefix="")
  all.features.col <<- c(train.col)
  # all.features.col <<- c(train.col,two.features.col)
  
  fmla <<- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))
  
  #divide into postive and negetive sample
  pos.sample <<- train.feature[which(train.feature[CLASS.INDEX] == "1"),]
  neg.sample <<- train.feature[which(train.feature[CLASS.INDEX] == "0"),]
  rm(train.feature)
  # samp <<- sort(sample(num,2000000))
  # sample positive sample and negetive sample seperately
  pos.num <<- nrow(pos.sample)
  neg.num <<- nrow(neg.sample)
}

train.sample.data <-function(){
  #calc time cost
  start.time <<- Sys.time()
  
#   pos.samp <- sort(sample(pos.num,300000))
#   neg.samp <- sort(sample(neg.num,1000000))
  pos.samp <- sort(sample(pos.num,300000))
  neg.samp <- sort(sample(neg.num,1000000))
  
  # get new train.feature
  new.train.feature <-rbind(pos.sample[pos.samp,],neg.sample[neg.samp,])
  #shuffle the data
  # new.train.feature <- new.train.feature[sample.int(pos.num+neg.num),]
  
  a <<- nnet(fmla,new.train.feature,size=9,rang=0.03,decay=5e-4,maxit=100,MaxNWts=999999)
  p <<- predict(a,test.feature[-CLASS.INDEX])
  
  m <- prediction(p,test.feature[CLASS.INDEX])
  
  auc <<- performance(m, "auc")

  end.time <<- Sys.time()
}



write.to.file <- function(){
  write.table(p,paste(BASE.PATH,"nnetPredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"nnetAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(data.frame(end.time-start.time),paste(BASE.PATH,"nnetTime",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}


write.to.file.i <- function(i){
  write.table(p,paste(BASE.PATH,"nnetPredictTest",i,sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"nnetAUC",i,sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
#   write.table(data.frame(end.time-start.time),paste(BASE.PATH,"nnetTime",i,sep=""),sep="\t",
#               quote = FALSE,row.names = FALSE,col.names=FALSE)
}
# 
# write.to.data.frame.i


train.all.data <-function(){
  
  start.time <- Sys.time()
  train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
  # train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
  num <- nrow(train.feature)
  CLASS.INDEX <-  ncol(train.feature)
  
  # samp <- sort(sample(num,1300000))
  train.col <- colnames(train.feature,prefix="")

  all.features.col <- c(train.col)
  
  #然后获得一般线性模型结果
  fmla <- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))
  
  # a <- nnet(fmla,train.feature[samp,],size=9,rang=0.03,decay=5e-4,maxit=100,MaxNWts=9999999)
  a <- nnet(fmla,train.feature,size=9,rang=0.03,decay=5e-4,maxit=1000,MaxNWts=9999999)
  
  test.feature <- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",")
  # test.feature <- read.table(paste(BASE.PATH,"tef",sep=""),sep=",")
  p=predict(a,test.feature[-CLASS.INDEX])
  
  write.table(p,paste(BASE.PATH,"nnetPredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  m=prediction(p,test.feature[CLASS.INDEX])

  auc <- performance(m, "auc")
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"nnetAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #calc time cost
  end.time <- Sys.time()
  
  write.table(data.frame(end.time-start.time),paste(BASE.PATH,"nnetTime",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

train.male.comm <-function(){
  
  start.time <- Sys.time()
  train.feature <- read.table(paste(SAVE.BASE.PATH,"trainMaleComm",sep=""),sep=",")
  test.feature <- read.table(paste(SAVE.BASE.PATH,"testMaleComm",sep=""),sep=",")
  train.feature <- train.feature[,c(-1,-2)]
  
  num <- nrow(train.feature)
  CLASS.INDEX <-  ncol(train.feature)
  test.row.no.col <- test.feature[,1]
  test.feature <- test.feature[,c(-1,-2)]
  train.col <- colnames(train.feature,prefix="")
  all.features.col <- c(train.col)
  
  fmla <- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))
  a <- nnet(fmla,train.feature,size=9,rang=0.03,decay=5e-4,maxit=1000,MaxNWts=9999999)
  
  p=predict(a,test.feature[-CLASS.INDEX])
  row.no.and.p <- cbind(test.row.no.col,p)
  write.table(row.no.and.p,paste(BASE.PATH,"testMaleCommPredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  m=prediction(p,test.feature[CLASS.INDEX])
  
  auc <- performance(m, "auc")
  auc@y.values
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"testMaleCommAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #calc time cost
  end.time <- Sys.time()
  write.table(data.frame(end.time-start.time),paste(BASE.PATH,"testMaleCommTime",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

train.female.comm <-function(){
  
  start.time <- Sys.time()
  train.feature <- read.table(paste(SAVE.BASE.PATH,"trainFemaleComm",sep=""),sep=",")
  test.feature <- read.table(paste(SAVE.BASE.PATH,"testFemaleComm",sep=""),sep=",")
  train.feature <- train.feature[,c(-1,-2)]
  
  num <- nrow(train.feature)
  CLASS.INDEX <-  ncol(train.feature)
  test.row.no.col <- test.feature[,1]
  test.feature <- test.feature[,c(-1,-2)]
  train.col <- colnames(train.feature,prefix="")
  all.features.col <- c(train.col)
  
  fmla <- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))
  a <- nnet(fmla,train.feature,size=9,rang=0.03,decay=5e-4,maxit=1000,MaxNWts=9999999)
  
  p=predict(a,test.feature[-CLASS.INDEX])
  row.no.and.p <- cbind(test.row.no.col,p)
  write.table(row.no.and.p,paste(BASE.PATH,"testFemaleCommPredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  m=prediction(p,test.feature[CLASS.INDEX])
  
  auc <- performance(m, "auc")
  auc@y.values
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"testFemaleCommAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #calc time cost
  end.time <- Sys.time()
  write.table(data.frame(end.time-start.time),paste(BASE.PATH,"testFemaleCommTime",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

train.male.diff<-function(){
  
  start.time <- Sys.time()
  train.feature <- read.table(paste(SAVE.BASE.PATH,"TrainingFeatures_m",sep=""),sep=",")
  test.feature <- read.table(paste(SAVE.BASE.PATH,"testMaleDiff",sep=""),sep=",")
  #remove row no. and user id
  train.feature <- train.feature[,c(-1,-2)]
  
  num <- nrow(train.feature)
  CLASS.INDEX <-  ncol(train.feature)
  test.row.no.col <- test.feature[,1]
  test.feature <- test.feature[,c(-1,-2)]
  train.col <- colnames(train.feature,prefix="")
  all.features.col <- c(train.col)
  
  fmla <- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))
  a <- nnet(fmla,train.feature,size=9,rang=0.03,decay=5e-4,maxit=100,MaxNWts=9999999)
  
  p=predict(a,test.feature[-CLASS.INDEX])
  row.no.and.p <- cbind(test.row.no.col,p)
  write.table(row.no.and.p,paste(BASE.PATH,"testMaleDiffPredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  m=prediction(p,test.feature[CLASS.INDEX])
  
  auc <- performance(m, "auc")
  auc@y.values
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"testMaleDiffAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #calc time cost
  end.time <- Sys.time()
  write.table(data.frame(end.time-start.time),paste(BASE.PATH,"testMaleDiffTime",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

train.female.diff<-function(){
  
  start.time <- Sys.time()
  train.feature <- read.table(paste(SAVE.BASE.PATH,"TrainingFeatures_f",sep=""),sep=",")
  test.feature <- read.table(paste(SAVE.BASE.PATH,"testFemaleDiff",sep=""),sep=",")
  #remove row no. and user id
  train.feature <- train.feature[,c(-1,-2)]
  
  num <- nrow(train.feature)
  CLASS.INDEX <-  ncol(train.feature)
  test.row.no.col <- test.feature[,1]
  test.feature <- test.feature[,c(-1,-2)]
  train.col <- colnames(train.feature,prefix="")
  all.features.col <- c(train.col)
  
  fmla <- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))
  a <- nnet(fmla,train.feature,size=9,rang=0.03,decay=5e-4,maxit=100,MaxNWts=9999999)
  
  p=predict(a,test.feature[-CLASS.INDEX])
  row.no.and.p <- cbind(test.row.no.col,p)
  write.table(row.no.and.p,paste(BASE.PATH,"testFemaleDiffPredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  m=prediction(p,test.feature[CLASS.INDEX])
  
  auc <- performance(m, "auc")
  auc@y.values
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"testFemaleDiffAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #calc time cost
  end.time <- Sys.time()
  write.table(data.frame(end.time-start.time),paste(BASE.PATH,"testFemaleDiffTime",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

merge.multi.models <- function(){
  train.male.comm <- read.table(paste(BASE.PATH,"testMaleCommPredictTest",sep=""),sep="\t")
  train.female.comm <- read.table(paste(BASE.PATH,"testFemaleCommPredictTest",sep=""),sep="\t")
  train.male.diff <- read.table(paste(BASE.PATH,"testMaleDiffPredictTest",sep=""),sep="\t")
  train.female.diff <- read.table(paste(BASE.PATH,"testFemaleDiffPredictTest",sep=""),sep="\t")
  merge.result <- rbind(train.male.comm,train.female.comm)
  merge.result <- rbind(merge.result,train.male.diff)
  merge.result <- rbind(merge.result,train.female.diff)
#   colnames(merge.result) <-c("x","p")
  merge.result <- merge.result[order(merge.result[,1]),]
  write.table(merge.result[,2],paste(BASE.PATH,"mergePredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(merge.result,paste(BASE.PATH,"mergePredictTestWithNo",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  test.feature <<- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",") 
  CLASS.INDEX <<-  ncol(test.feature)
  test.class.index <- test.feature[merge.result[,1],CLASS.INDEX]
  m=prediction(p,test.class.index)
  auc <- performance(m, "auc")
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"mergeAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  
}

init.simple.env()
# train.male.comm()
# train.female.comm()
# train.male.diff()
# train.female.diff()
merge.multi.models()


main <- function(){
  init.env()
  train.sample.data()
  auc@y.values
  write.to.file()
}

# main()
# library(nnet);  #安装nnet软件包
# library(mlbench);  #安装mlbench软件包
# data(Vehicle);  #调入数据
# n=length(Vehicle[,1]); #样本量
# set.seed(1);  #设随机数种子
# samp=sample(1:n,n/2);  #随机选择半数观测作为训练集
# b=class.ind(Vehicle$Class);  #生成类别的示性函数
# test.cl=function(true,pred){true<-max.col(true);cres=max.col(pred);table(true,cres)};
# a=nnet(Vehicle[samp,-19],b[samp,],size=3,rang=0.1,decay=5e-4,maxit=200);  #利用训练集中前18个变量作为输入变量，隐藏层有3个节点，初始随机权值在[-0.1,0.1]，权值是逐渐衰减的。
# test.cl(b[samp,],predict(a,Vehicle[samp,-19]))#给出训练集分类结果
# test.cl(b[-samp,],predict(a,Vehicle[-samp,-19]));#给出测试集分类结果
# #构建隐藏层包含15个节点的网络。接着上面的语句输入如下程序：
# a=nnet(Vehicle[samp,-19],b[samp,],size=15,rang=0.1,decay=5e-4,maxit=10000);
# test.cl(b[samp,],predict(a,Vehicle[samp,-19]));
# test.cl(b[-samp,],predict(a,Vehicle[-samp,-19]));