library(plyr)
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"

train <- read.table(paste(BASE.PATH,"train",sep=""),sep=",")
train <- train[,c(-3,-4)]
colnames(train) <- c("user","ad","imp","clk")

rate <- function(imp,clk){
  clk/(imp+clk)
}

#user-ad clk rate
train <- ddply(train,.(user,ad),summarize,
               imps=sum(imp),clks=sum(clk),userAdRate=rate(imps,clks))
write.table(train,paste(BASE.PATH,"userAdRate",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
#user clk rate
train.user <- ddply(train,.(user),summarize,
               imp=sum(imps),clk=sum(clks),userRate=rate(imp,clk))
write.table(train.user,paste(BASE.PATH,"userRate",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
#ad clk rate
train.ad <- ddply(train,.(ad),summarize,
                    imp=sum(imps),clk=sum(clks),adRate=rate(imp,clk))
write.table(train.ad,paste(BASE.PATH,"adRate",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
