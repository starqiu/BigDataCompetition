# library(ROCR)

# BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"
BASE.PATH <- "/home/xqiu/kdd/data/"

ATTEMPT.TIMES <- 5

train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
# train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
# train.col.names <- c("Sex","Age","RegistAge","Region",
#                      "保险","测试","促销","电子产品",
#                      "服装","婚介","婚庆","家居","健康",
#                      "教育","理财","旅游","美发","美容",
#                      "男性","女裙","女性","其它","汽车",
#                      "食品","饰品","手表","鞋子","婴幼护理","游戏")
train.col.names <- c("V1","V2","V3","V4",
                     "V5","V6","V7","V8",
                     "V9","V10","V11","V12","V13",
                     "V14","V15","V16","V17","V18",
                     "V19","V20","V21","V22","V23",
                     "V24","V25","V26","V27","V28","V29")
CLASS.INDEX <-  ncol(train.feature)
pos.sample <- train.feature[which(train.feature[CLASS.INDEX] == "1"),]
neg.sample <- train.feature[which(train.feature[CLASS.INDEX] == "0"),]

pos.num <- nrow(pos.sample)
neg.num <- nrow(neg.sample)
feature.length <- length(train.col.names)
# 
# test.result.df <- read.table("/host/kp/siat/KDD/ccf_contest/tTest/tTestResultFor2FeaturesWithSelf",
#                              header=TRUE,sep="\t")
# test.col.names <-colnames(test.result.df,prefix="")
# test.col.mean <-apply(test.result.df,2,mean)
# test.mean.df <-cbind(test.col.names,test.col.mean)
# 
# sorted.result.df <- test.mean.df[order(test.mean.df[,2]),]
# write.table(sorted.result.df,paste(BASE.PATH,"sortedTTestResultFor2FeaturesWithSelf",sep=""),
#             sep="\t",quote = FALSE,row.names=FALSE,col.names=FALSE)

# two.features.total.num <-feature.length*(feature.length+1)/2
# three.features.total.num <- feature.length *two.features.total.num
# three.features.col.names <-rep("",three.features.total.num)
# result.matrix <- matrix(nrow=ATTEMPT.TIMES,ncol=three.features.total.num)
# for(k in 1:ATTEMPT.TIMES){
#   samp <- sort(sample(neg.num,pos.num)) 
#   for (m in 1:feature.length){
#     for (i in m:feature.length){
#       for (j in i:feature.length){
#                   t.test.result <- t.test(pos.sample[,i]*pos.sample[,j],
#                                           neg.sample[samp,i]*neg.sample[samp,j])
#         col.index <- two.features.total.num*(m-1)+feature.length*(i-1)-(i-1)*(i-2)/2 + j-i+1
#         result.matrix[k,col.index] <-  t.test.result$p.value
#         three.features.col.names[col.index] <- paste(train.col.names[m],
#                                                      "_",train.col.names[i],
#                                                      "_",train.col.names[j],
#                                                      sep="")
#       }
#       
#     }
#   }
# }
# result.data.frame <- as.data.frame(result.matrix)
# colnames(result.data.frame)<-three.features.col.names
# write.table(result.data.frame,paste(BASE.PATH,"tTestResultFor3FeaturesWithSelf",sep=""),
#             sep="\t",quote = FALSE,row.names=FALSE)
# 
# test.result.df <- read.table(paste(BASE.PATH,"tTestResultFor3FeaturesWithSelf",sep=""),
#                              header=TRUE,sep="\t")
# test.col.names <-colnames(test.result.df,prefix="")
# test.col.mean <-apply(test.result.df,2,mean)
# test.mean.df <-cbind(test.col.names,test.col.mean)
# 
# sorted.result.df <- test.mean.df[order(test.mean.df[,2]),]
# write.table(sorted.result.df,paste(BASE.PATH,"sortedTTestResultFor3FeaturesWithSelf",sep=""),
#             sep="\t",quote = FALSE,row.names=FALSE,col.names=FALSE)


three.features.test<-function(){
  two.features.total.num <-feature.length*(feature.length+1)/2
  three.features.total.num <- feature.length *two.features.total.num
  three.features.col.names <-rep("",three.features.total.num)
  result.matrix <- matrix(nrow=ATTEMPT.TIMES,ncol=three.features.total.num)
  for(k in 1:ATTEMPT.TIMES){
    samp <- sort(sample(neg.num,pos.num)) 
    for (m in 1:feature.length){
      for (i in m:feature.length){
        for (j in i:feature.length){
          t.test.result <- t.test(pos.sample[,m]*pos.sample[,i]*pos.sample[,j],
                                  neg.sample[samp,m]*neg.sample[samp,i]*neg.sample[samp,j])
          
          col.index <- two.features.total.num*(m-1)+feature.length*(i-1)-(i-1)*(i-2)/2 + j-i+1
          result.matrix[k,col.index] <- t.test.result$p.value
          three.features.col.names[col.index] <- paste(train.col.names[m],
                                                       "_",train.col.names[i],
                                                       "_",train.col.names[j],
                                                       sep="")
        }
        
      }
    }
  }
  result.data.frame <- as.data.frame(result.matrix)
  colnames(result.data.frame)<-three.features.col.names
  write.table(result.data.frame,paste(BASE.PATH,"tTestResultFor3FeaturesWithSelf",sep=""),
              sep="\t",quote = FALSE,row.names=FALSE)
  
  test.result.df <- read.table(paste(BASE.PATH,"tTestResultFor3FeaturesWithSelf",sep=""),
                               header=TRUE,sep="\t")
  test.col.names <-colnames(test.result.df,prefix="")
  test.col.mean <-apply(test.result.df,2,mean)
  test.mean.df <-cbind(test.col.names,test.col.mean)
  
  sorted.result.df <- test.mean.df[order(test.mean.df[,2]),]
  write.table(sorted.result.df,paste(BASE.PATH,"sortedTTestResultFor3FeaturesWithSelf",sep=""),
              sep="\t",quote = FALSE,row.names=FALSE,col.names=FALSE)
}
three.features.test()

two.features.test<-function(){
  two.features.total.num <-feature.length*(feature.length+1)/2
  two.features.col.names <-rep("",two.features.total.num)
  result.matrix <- matrix(nrow=ATTEMPT.TIMES,ncol=two.features.total.num)
  for(k in 1:ATTEMPT.TIMES){
    samp <- sort(sample(neg.num,pos.num)) 
    for (i in 1:feature.length){
      for (j in i:feature.length){
        t.test.result <- t.test(pos.sample[,i]*pos.sample[,j],
                                neg.sample[samp,i]*neg.sample[samp,j])
        col.index <- feature.length*(i-1) - (i-1)*(i-2)/2 + j-i+1
        result.matrix[k,col.index] <- t.test.result$p.value
        two.features.col.names[col.index] <- paste(train.col.names[i],
                                                   "_",train.col.names[j],
                                                   sep="")
      }
      
    }
  }
  result.data.frame <- as.data.frame(result.matrix)
  colnames(result.data.frame)<-two.features.col.names
  write.table(result.data.frame,paste(BASE.PATH,"tTestResultFor2FeaturesWithSelf",sep=""),
              sep="\t",quote = FALSE,row.names=FALSE)
  
  test.result.df <- read.table(paste(BASE.PATH,"tTestResultFor2FeaturesWithSelf",sep=""),
                               header=TRUE,sep="\t")
  test.col.names <-colnames(test.result.df,prefix="")
  test.col.mean <-apply(test.result.df,2,mean)
  test.mean.df <-cbind(test.col.names,test.col.mean)
  
  sorted.result.df <- test.mean.df[order(test.mean.df[,2]),]
  write.table(sorted.result.df,paste(BASE.PATH,"sortedTTestResultFor2FeaturesWithSelf",sep=""),
              sep="\t",quote = FALSE,row.names=FALSE,col.names=FALSE)
  
}
two.features.test()

one.feature.test<-function(){
  result.matrix <- matrix(nrow=ATTEMPT.TIMES,ncol=feature.length)
  for(j in 1:ATTEMPT.TIMES){
    samp <- sort(sample(neg.num,pos.num)) 
    for (i in 1:feature.length){
      t.test.result <- t.test(pos.sample[,i],neg.sample[samp,i])
      result.matrix[j,i] <- t.test.result$p.value
      
    }
  }
  result.data.frame <- as.data.frame(result.matrix)
  colnames(result.data.frame)<-train.col.names
  write.table(result.data.frame,paste(BASE.PATH,"tTestResultDF",sep=""),
              sep="\t",quote = FALSE,row.names=FALSE)
  
}
one.feature.test()