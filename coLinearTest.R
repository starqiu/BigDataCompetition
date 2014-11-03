CLASS.INDEX <- 30
BASE.PATH <- "/home/xqiu/kdd/data/"
# BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"

train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
# train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
CLASS.INDEX <-  ncol(train.feature)

c <- cor(train.feature[,-CLASS.INDEX])
k <- kappa(c, exact=T) 
k
print(k)