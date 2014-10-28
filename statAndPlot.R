library(scatterplot3d)
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/"

stat.and.plot.ad.feature <- function(){
  ad <- read.table(paste(BASE.PATH,"ads.txt",sep=""),header=TRUE,sep="\t")
  ad <- ad[,c(-1,-2,-3)]
  ad.col.names <<- colnames(ad)
  feature.length <- length(ad.col.names)
  for (i in 1:feature.length){
    col <-as.numeric(ad[,i])
    png(paste(ad.col.names[i],".png",sep=""))
    hist(col,main=paste("Hist of ",ad.col.names[i]))
    dev.off()
  }
}

stat.and.plot.user.feature <- function(){
  user <- read.table(paste(BASE.PATH,"users",sep=""),sep=",")
  age <- as.vector(user[,3])
  age[age== "\\N"] <-0
  age <- as.numeric(age)
  write.table(age,paste(BASE.PATH,"age",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  png("age.png")
  hist(age,main="Hist of age")
  dev.off()
  
  regist <- as.vector(user[,4])
  regist[regist== "\\N"] <-0
  regist <- as.numeric(regist)
  write.table(regist,paste(BASE.PATH,"regist",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  png("registration.png")
  hist(regist,main="Hist of regist")
  dev.off()
  
  region <- as.vector(user[,5])
  region[region== "\\N"] <-0
  region <- as.numeric(region)
  write.table(region,paste(BASE.PATH,"region",sep=""),sep="\t",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  png("region.png")
  hist(region,main="Hist of region")
  dev.off()
}
# stat.and.plot.user.feature()

train <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
train.col.names <- c("Sex","Age","Regist Age","Region",
                     "保险","测试","促销","电子产品",
                     "服装","婚介","婚庆","家居","健康",
                     "教育","理财","旅游","美发","美容",
                     "男性","女裙","女性","其它","汽车",
                     "食品","饰品","手表","鞋子","婴幼护理","游戏")
feature.length <- length(train.col.names)
for (i in 1:feature.length){
  col <-as.numeric(train[,i])
  png(paste(train.col.names[i],".png",sep=""))
  hist(col,main=paste("Hist of ",train.col.names[i],"in training sample"))
  dev.off()
}

stat.and.plot.training.feature <- function(){
  train <- read.table(paste(BASE.PATH,"um/trf",sep=""),sep=",")
  train.col.names <- c("Sex","Age","Regist Age","Region",ad.col.names)
  feature.length <- length(train.col.names)
  for (i in 1:feature.length){
    col <-as.numeric(train[,i])
    png(paste(train.col.names[i],".png",sep=""))
    hist(col,main=paste("Hist of ",train.col.names[i],"in training sample"))
    dev.off()
  }
}


#训练集
draw.region <- function(){
  
  png("train.png")
  attach(train)
  opar <- par(no.readonly = TRUE)
  par(mfrow = c(4,1))
  hist(pref,main="Hist of pref")
  plot(user,item,main="Scatterplot of user vs. item")
  abline(lm(user~item))
  plot(user,pref,main="Scatterplot of user vs. pref")
  abline(lm(user~pref))
  boxplot(pref,main="Boxplot of pref")
  par(opar)
  detach(train)
  dev.off()
  
}
#draw.region()

#同现矩阵
draw.step2 <- function(){
  step2 <- read.table('step2Mr.txt',
                      header = F,
                      dec = '.',
                      col.names = c("k.item","item1","item2","freq"),
                      na.strings = c('XXXXXX'))
  
  png("step2.png")
  attach(step2)
  opar <- par(no.readonly = TRUE)
  par(mfrow = c(1,1)) 
  s3d <- scatterplot3d(item1,item2,freq,
                       pch=16,
                       highlight.3d=TRUE,
                       col.axis="blue",
                       col.grid="lightblue",
                       type="h",
                       main="the scatterplot3d of cooccurrence matrix")
  fit <- lm(freq ~ item1 + item2)
  s3d$plane3d(fit,lty.box = "solid")
  par(opar)
  detach(step2)
  dev.off()
  
}
#draw.step2()