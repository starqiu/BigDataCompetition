# library(ROCR)

BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"
# CLASS.INDEX <- 30
ATTEMPT.TIMES <- 5

# train <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
train <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
train.col.names <- c("Sex","Age","Regist Age","Region",
                     "保险","测试","促销","电子产品",
                     "服装","婚介","婚庆","家居","健康",
                     "教育","理财","旅游","美发","美容",
                     "男性","女裙","女性","其它","汽车",
                     "食品","饰品","手表","鞋子","婴幼护理","游戏")

pos.sample <- train[which(train[30] == "1"),]
neg.sample <- train[which(train[30] == "0"),]

pos.num <- nrow(pos.sample)
neg.num <- nrow(neg.sample)
feature.length <- length(train.col.names)

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
write.table(result.data.frame,paste(BASE.PATH,"tTestResult",sep=""),
            sep="\t",quote = FALSE,row.names=FALSE)
