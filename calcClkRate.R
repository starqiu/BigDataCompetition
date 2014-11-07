library(plyr)
# BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/"
BASE.PATH <<- "/home/xqiu/kdd/data/"
# SAVE.BASE.PATH <<- "/home/xqiu/kdd/data/clkRate/"

rate <- function(imp,clk){
  clk/(imp+clk)
}

rate.smooth <- function(imp,clk,alpha=0.05,beta=75){
#   alpha <-0.05
#   beta <-75
  (clk+alpha*beta)/(imp+clk+beta)
}

calc.clk.rate <- function(rate){
  train <- read.table(paste(BASE.PATH,"training.txt",sep=""),sep=",")
  train <- train[,c(-3,-4)]
  colnames(train) <- c("user","ad","imp","clk")
  
  #user-ad clk rate
  train <- ddply(train,.(user,ad),summarize,
                 imps=sum(imp),clks=sum(clk),userAdRate=rate(imps,clks))
  write.table(train,paste(BASE.PATH,"trainUserAdRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #user clk rate
  train.user <- ddply(train,.(user),summarize,
                      imp=sum(imps),clk=sum(clks),userRate=rate(imp,clk))
  write.table(train.user,paste(BASE.PATH,"trainUserRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #ad clk rate
  train.ad <- ddply(train,.(ad),summarize,
                    imp=sum(imps),clk=sum(clks),adRate=rate(imp,clk))
  write.table(train.ad,paste(BASE.PATH,"trainAdRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}
# calc.clk.rate(rate)


calc.test.clk.rate <- function(rate){
  train <- read.table(paste(BASE.PATH,"testing.txt",sep=""),sep=",")
  train <- train[,c(-3,-4)]
  colnames(train) <- c("user","ad","imp","clk")
  
  #user-ad clk rate
  train <- ddply(train,.(user,ad),summarize,
                 imps=sum(imp),clks=sum(clk),userAdRate=rate(imps,clks))
  write.table(train,paste(BASE.PATH,"testUserAdRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #user clk rate
  train.user <- ddply(train,.(user),summarize,
                      imp=sum(imps),clk=sum(clks),userRate=rate(imp,clk))
  write.table(train.user,paste(BASE.PATH,"testUserRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  #ad clk rate
  train.ad <- ddply(train,.(ad),summarize,
                    imp=sum(imps),clk=sum(clks),adRate=rate(imp,clk))
  write.table(train.ad,paste(BASE.PATH,"testAdRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}
# calc.test.clk.rate(rate.smooth)

merge.train.and.test.clk.rate <- function(rate){
  
  RATE.INDEX <- 4
  
  train.user <- read.table(paste(BASE.PATH,"smoothedTrainUserRate",sep=""),sep="\t")[,-RATE.INDEX]
  train.ad <- read.table(paste(BASE.PATH,"smoothedTrainAdRate",sep=""),sep="\t")[,-RATE.INDEX]
  test.user <- read.table(paste(BASE.PATH,"testUserRate",sep=""),sep="\t")[,-RATE.INDEX]
  test.ad <- read.table(paste(BASE.PATH,"testAdRate",sep=""),sep="\t")[,-RATE.INDEX]
  
  all.user <- rbind(train.user,test.user)
  all.ad <- rbind(train.ad,test.ad)
  colnames(all.user) <- c("user","imp","clk")
  colnames(all.ad) <- c("ad","imp","clk")
  
  user.clk.rate <- ddply(all.user,.(user),summarize,
                      imps=sum(imp),clks=sum(clk),userRate=rate(imps,clks))
  write.table(user.clk.rate,paste(BASE.PATH,"smoothedUserRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  ad.clk.rate <- ddply(all.ad,.(ad),summarize,
                         imps=sum(imp),clks=sum(clk),userRate=rate(imps,clks)) 
  write.table(ad.clk.rate,paste(BASE.PATH,"smoothedAdRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}

merge.train.and.test.clk.rate(rate.smooth)

calc.smooth.rate <-function(rate.smooth){
  train.user <- read.table(paste(BASE.PATH,"trainUserRate",sep=""),sep="\t")
  train.ad <- read.table(paste(BASE.PATH,"trainAdRate",sep=""),sep="\t")
  
  # colnames(train.user) <- c("user","imp","clk","rate")
  # colnames(train.ad) <- c("ad","imp","clk","rate")
  
  train.user[4] <- rate.smooth(train.user[,2],train.user[,3])
  train.ad[4] <- rate.smooth(train.ad[,2],train.ad[,3])
  
  write.table(train.user,paste(BASE.PATH,"smoothedTrainUserRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(train.ad,paste(BASE.PATH,"smoothedTrainAdRate",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
}

# calc.smooth.rate(rate.smooth)
