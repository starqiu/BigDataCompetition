library(plyr)
# BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/"
BASE.PATH <<- "/home/xqiu/kdd/data/"

train.merge <- function(){
  train <- read.table(paste(BASE.PATH,"training.txt",sep=""),sep=",")
  # train <- read.table(paste(BASE.PATH,"train",sep=""),sep=",")
  # train <- train[,c(-3,-4,-5)]
  colnames(train) <- c("user","ad","ader","creative","imp","clk")
  new.train <- ddply(train,.(user,ad,clk),summarize,
                     num=length(clk))
  write.table(new.train[,-4],paste(BASE.PATH,"newTraining.txt",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(new.train[,4],paste(BASE.PATH,"newTrainingCount.txt",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}

test.generalized <- function(){
  test <- read.table(paste(BASE.PATH,"testing.txt",sep=""),sep=",")
  # train <- read.table(paste(BASE.PATH,"train",sep=""),sep=",")
  test <- test[,c(-3,-4,-5)]
  colnames(test) <- c("user","ad","class.index")
}

# train.merge()

new.train <- read.table(paste(BASE.PATH,"newTraining_bk.txt",sep=""),sep=",")
write.table(new.train[,-4],paste(BASE.PATH,"newTraining.txt",sep=""),sep=",",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
write.table(new.train[,4],paste(BASE.PATH,"newTrainingCount.txt",sep=""),sep=",",
            quote = FALSE,row.names = FALSE,col.names=FALSE)