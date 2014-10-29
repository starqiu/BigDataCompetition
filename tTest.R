# library(ROCR)

BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"

ATTEMPT.TIMES <- 5

# train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
# train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
# train.col.names <- c("Sex","Age","Regist Age","Region",
#                      "保险","测试","促销","电子产品",
#                      "服装","婚介","婚庆","家居","健康",
#                      "教育","理财","旅游","美发","美容",
#                      "男性","女裙","女性","其它","汽车",
#                      "食品","饰品","手表","鞋子","婴幼护理","游戏")
# CLASS.INDEX <-  ncol(train.feature)
# pos.sample <- train.feature[which(train.feature[CLASS.INDEX] == "1"),]
# neg.sample <- train.feature[which(train.feature[CLASS.INDEX] == "0"),]
# 
# pos.num <- nrow(pos.sample)
# neg.num <- nrow(neg.sample)
# feature.length <- length(train.col.names)

test.result.df <- read.table("/host/kp/siat/KDD/ccf_contest/tTest/tTestResultFor2Features",
                             header=TRUE,sep="\t")
test.col.names <-colnames(test.result.df,prefix="")
test.col.mean <-apply(test.result.df,2,mean)
test.mean.df <-cbind(test.col.names,test.col.mean)

sorted.result.df <- test.mean.df[order(test.mean.df[,2]),]
write.table(sorted.result.df,paste(BASE.PATH,"sortedTTestResultFor2Features",sep=""),
            sep="\t",quote = FALSE,row.names=FALSE,col.names=FALSE)


two.features.test<-function(){
  two.features.total.num <-feature.length*(feature.length-1)/2
  two.features.col.names <-rep("",two.features.total.num)
  result.matrix <- matrix(nrow=ATTEMPT.TIMES,ncol=two.features.total.num)
  for(k in 1:ATTEMPT.TIMES){
    samp <- sort(sample(neg.num,pos.num)) 
    for (i in 1:(feature.length-1)){
      for (j in (i+1):feature.length){
        t.test.result <- t.test(pos.sample[,i]*pos.sample[,j],
                                neg.sample[samp,i]*neg.sample[samp,j])
        col.index <- feature.length*(i-1) - (i-1)*i/2 + j-i
        result.matrix[k,col.index] <- t.test.result$p.value
        two.features.col.names[col.index] <- paste(train.col.names[i],
                                                   "*",train.col.names[j],
                                                   sep="")
      }
      
    }
  }
  result.data.frame <- as.data.frame(result.matrix)
  colnames(result.data.frame)<-two.features.col.names
  write.table(result.data.frame,paste(BASE.PATH,"tTestResultFor2Features",sep=""),
              sep="\t",quote = FALSE,row.names=FALSE)
}


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
