library(ROCR)
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"
COMBINE.BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/results/"


simple.calc.auc <- function(){
  p <- read.table(paste(BASE.PATH,"predict_rbf.txt",sep=""))
  # test.feature <- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",")
  # samp <-  1:2731704
  # samp <-samp*2
  # rp <- p[samp,1]
  # write.table(test.feature[,30],paste(BASE.PATH,"TestingClassIndex",sep=""),sep="\t",
  #             quote = FALSE,row.names = FALSE,col.names=FALSE)
  test.class.index <- read.table(paste(BASE.PATH,"TestingClassIndex",sep=""))
  m=prediction(p,test.class.index)
  # png("ROC.png")
  # plot(performance(m,'tpr','fpr'))
  # abline(0,1, lty = 8, col = "grey")
  # dev.off()
  
  # 另一个相关的衡量标准就是ROC图的曲线下面积，
  # 许多的数据挖掘大赛会用它来作为最终的评价指标
  
  auc <- performance(m, "auc")
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"AUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}

merge.multi.models <- function(){
  SEP <- "\t"
#   train.male <- read.table(paste(COMBINE.BASE.PATH,"male_predict.txt",sep=""),sep=SEP)
#   train.female <- read.table(paste(COMBINE.BASE.PATH,"female_predict.txt",sep=""),sep=SEP)
  train.male.comm <- read.table(paste(COMBINE.BASE.PATH,"old_male_predict.txt",sep=""),sep=SEP)
  train.female.comm <- read.table(paste(COMBINE.BASE.PATH,"old_female_predict.txt",sep=""),sep=SEP)
  train.male.diff <- read.table(paste(COMBINE.BASE.PATH,"diff_male_predict.txt",sep=""),sep=SEP)
  train.female.diff <- read.table(paste(COMBINE.BASE.PATH,"diff_female_predict.txt",sep=""),sep=SEP)
  train.unknown.sex <- read.table(paste(COMBINE.BASE.PATH,"sexunknown_predict.txt",sep=""),sep=SEP)
#   merge.result <- rbind(train.male,train.female)
  merge.result <- rbind(train.male.comm,train.female.comm)
  merge.result <- rbind(merge.result,train.male.diff)
  merge.result <- rbind(merge.result,train.female.diff)
  merge.result <- rbind(merge.result,train.unknown.sex)
  #   colnames(merge.result) <-c("x","p")
  merge.result <- merge.result[order(merge.result[,1]),]
  write.table(merge.result[,2],paste(BASE.PATH,"mergePredictTest",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
#   write.table(merge.result,paste(BASE.PATH,"mergePredictTestWithNo",sep=""),sep="\t",
#               quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  test.class.index <- read.table(paste(BASE.PATH,"TestingClassIndex",sep=""))
  m=prediction(merge.result[,2],test.class.index[merge.result[,1],])
  auc <- performance(m, "auc")
  write.table(data.frame(auc@y.values),paste(BASE.PATH,"mergeAUC",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

# merge.multi.models()
SEP <- ","
#   train.male <- read.table(paste(COMBINE.BASE.PATH,"male_predict.txt",sep=""),sep=SEP)
#   train.female <- read.table(paste(COMBINE.BASE.PATH,"female_predict.txt",sep=""),sep=SEP)
train.male.comm <- read.table(paste(COMBINE.BASE.PATH,"old_male_predict.txt",sep=""),sep=SEP)
train.female.comm <- read.table(paste(COMBINE.BASE.PATH,"old_female_predict.txt",sep=""),sep=SEP)
train.male.diff <- read.table(paste(COMBINE.BASE.PATH,"diff_male_predict.txt",sep=""),sep=SEP)
train.female.diff <- read.table(paste(COMBINE.BASE.PATH,"diff_female_predict.txt",sep=""),sep=SEP)
# train.unknown.sex <- read.table(paste(COMBINE.BASE.PATH,"sexunknown_predict.txt",sep=""),sep=SEP)
#   merge.result <- rbind(train.male,train.female)
merge.result <- rbind(train.male.comm,train.female.comm)
merge.result <- rbind(merge.result,train.male.diff)
merge.result <- rbind(merge.result,train.female.diff)
merge.result <- rbind(merge.result,train.unknown.sex)
#   colnames(merge.result) <-c("x","p")
merge.result <- merge.result[order(merge.result[,1]),]
write.table(merge.result[,2],paste(BASE.PATH,"mergePredictTest1",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
#   write.table(merge.result,paste(BASE.PATH,"mergePredictTestWithNo",sep=""),sep="\t",
#               quote = FALSE,row.names = FALSE,col.names=FALSE)

# test.class.index <- read.table(paste(BASE.PATH,"TestingClassIndex",sep=""))
m=prediction(merge.result[,2],test.class.index[merge.result[,1],])
auc <- performance(m, "auc")
auc.value <- auc@y.values
write.table(data.frame(auc@y.values),paste(BASE.PATH,"mergeAUC1",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)