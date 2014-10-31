library(ROCR)
library(nnet)

BASE.PATH <- "/home/xqiu/kdd/data/"
# BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"
REMOVE.FEATRUE.INDEX <-c(5,28)

start.time <- Sys.time()
train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
# train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
# num <- nrow(train.feature)
CLASS.INDEX <-  ncol(train.feature)
train.col <- colnames(train.feature,prefix="")
#divide into postive and negetive sample
pos.sample <- train.feature[which(train.feature[CLASS.INDEX] == "1"),]
neg.sample <- train.feature[which(train.feature[CLASS.INDEX] == "0"),]
rm(train.feature)
# samp <- sort(sample(num,2000000))
# sample positive sample and negetive sample seperately
pos.num <- nrow(pos.sample)
neg.num <- nrow(neg.sample)
pos.samp <- sort(sample(pos.num,300000))
neg.samp <- sort(sample(neg.num,1000000))

# get new train.feature
new.train.feature <-rbind(pos.sample[pos.samp,],neg.sample[neg.samp,])
#shuffle the data
# new.train.feature <- new.train.feature[sample.int(pos.num+neg.num),]

# two.features.col <- c("I ( V1*V2 )","I ( V1*V3 )","I ( V1*V4 )","I ( V1*V8 )","I ( V1*V9 )","I ( V1*V11 )","I ( V1*V17 )","I ( V1*V19 )","I ( V1*V20 )","I ( V1*V21 )","I ( V1*V27 )","I ( V1*V29 )","I ( V2*V2 )","I ( V2*V3 )","I ( V2*V4 )","I ( V2*V8 )","I ( V2*V9 )","I ( V2*V17 )","I ( V2*V20 )","I ( V2*V21 )","I ( V2*V27 )","I ( V2*V29 )","I ( V3*V3 )","I ( V3*V8 )","I ( V3*V9 )","I ( V3*V17 )","I ( V3*V19 )","I ( V3*V20 )","I ( V3*V21 )","I ( V3*V27 )","I ( V3*V29 )","I ( V4*V8 )","I ( V4*V9 )","I ( V4*V17 )","I ( V4*V20 )","I ( V4*V21 )","I ( V4*V27 )","I ( V4*V29 )","I ( V8*V8 )","I ( V9*V9 )","I ( V9*V21 )","I ( V17*V17 )","I ( V20*V20 )","I ( V21*V21 )","I ( V21*V27 )","I ( V27*V27 )","I ( V29*V29 )","I ( V19*V26 )","I ( V3*V12 )","I ( V13*V13 )","I ( V10*V11 )","I ( V19*V29 )","I ( V8*V18 )","I ( V8*V21 )","I ( V12*V1 )","I ( V3*V11 )","I ( V4*V13 )","I ( V1*V16 )","I ( V3*V13 )","I ( V2*V13 )","I ( V25*V25 )","I ( V1*V25 )","I ( V4*V24 )","I ( V15*V15 )","I ( V2*V16 )","I ( V4*V25 )","I ( V2*V11 )","I ( V2*V26 )","I ( V1*V14 )","I ( V4*V7 )","I ( V2*V2 )","I ( V2*V25 )","I ( V23*V23 )","I ( V3*V7 )","I ( V3*V10 )","I ( V23*V27 )","I ( V1*V6 )","I ( V4*V10 )","I ( V4*V23 )","I ( V3*V23 )","I ( V9*V20 )","I ( V7*V7 )","I ( V1*V23 )","I ( V19*V21 )","I ( V18*V19 )","I ( V4*V15 )","I ( V25*V29 )","I ( V3*V6 )","I ( V4*V11 )","I ( V20*V21 )","I ( V21*V29 )","I ( V4*V19 )","I ( V3*V15 )","I ( V3*V18 )","I ( V4*V4 )","I ( V22*V22 )","I ( V1*V10 )","I ( V1*V22 )","I ( V19*V25 )","I ( V2*V7 )","I ( V3*V16 )","I ( V3*V22 )","I ( V2*V14 )","I ( V1*V26 )","I ( V2*V24 )","I ( V10*V19 )","I ( V2*V6 )","I ( V2*V10 )","I ( V21*V25 )","I ( V26*V26 )","I ( V4*V26 )","I ( V11*V11 )","I ( V9*V19 )","I ( V1*V12 )","I ( V3*V24 )","I ( V6*V6 )","I ( V4*V22 )","I ( V4*V14 )","I ( V2*V18 )","I ( V9*V18 )","I ( V2*V19 )","I ( V14*V14 )","I ( V1*V1 )","I ( V2*V22 )","I ( V4*V16 )","I ( V16*V16 )","I ( V3*V14 )","I ( V3*V4 )","I ( V4*V6 )","I ( V1*V15 )","I ( V12*V28 )","I ( V11*V19 )","I ( V24*V24 )","I ( V19*V19 )","I ( V10*V10 )","I ( V2*V15 )","I ( V8*V12 )","I ( V8*V19 )","I ( V3*V25 )")
two.features.col <- c("I ( V1*V2 )","I ( V1*V3 )","I ( V1*V4 )","I ( V1*V8 )","I ( V1*V9 )","I ( V1*V11 )","I ( V1*V17 )","I ( V1*V19 )","I ( V1*V20 )","I ( V1*V21 )","I ( V1*V27 )","I ( V1*V29 )")

three.features.col <-c("I ( V1*V1*V1 ) " ,  "I ( V1*V1*V2 ) " ,  "I ( V1*V1*V3 ) " ,  "I ( V1*V1*V8 ) " ,  "I ( V1*V1*V9 ) " ,  "I ( V1*V1*V17 ) " ,  "I ( V1*V1*V20 ) " ,  "I ( V1*V1*V21 ) " ,  "I ( V1*V1*V27 ) " ,  "I ( V1*V1*V29 ) " ,  "I ( V1*V2*V2 ) " ,  "I ( V1*V2*V3 ) " ,  "I ( V1*V2*V4 ) " ,  "I ( V1*V2*V8 ) " ,  "I ( V1*V2*V9 ) " ,  "I ( V1*V2*V11 ) " ,  "I ( V1*V2*V17 ) " ,  "I ( V1*V2*V20 ) " ,  "I ( V1*V2*V21 ) " ,  "I ( V1*V2*V27 ) " ,  "I ( V1*V2*V29 ) " ,  "I ( V1*V3*V3 ) " ,  "I ( V1*V3*V4 ) " ,  "I ( V1*V3*V8 ) " ,  "I ( V1*V3*V9 ) " ,  "I ( V1*V3*V17 ) " ,  "I ( V1*V3*V19 ) " ,  "I ( V1*V3*V20 ) " ,  "I ( V1*V3*V21 ) " ,  "I ( V1*V3*V27 ) " ,  "I ( V1*V3*V29 ) " ,  "I ( V1*V4*V4 ) " ,  "I ( V1*V4*V8 ) " ,  "I ( V1*V4*V9 ) " ,  "I ( V1*V4*V11 ) " ,  "I ( V1*V4*V17 ) " ,  "I ( V1*V4*V19 ) " ,  "I ( V1*V4*V20 ) " ,  "I ( V1*V4*V21 ) " ,  "I ( V1*V4*V27 ) " ,  "I ( V1*V4*V29 ) " ,  "I ( V1*V8*V8 ) " ,  "I ( V1*V9*V9 ) " ,  "I ( V1*V9*V21 ) " ,  "I ( V1*V11*V11 ) " ,  "I ( V1*V17*V17 ) " ,  "I ( V1*V19*V19 ) " ,  "I ( V1*V19*V27 ) " ,  "I ( V1*V20*V20 ) " ,  "I ( V1*V21*V21 ) " ,  "I ( V1*V21*V27 ) " ,  "I ( V1*V27*V27 ) " ,  "I ( V1*V29*V29 ) " ,  "I ( V2*V2*V2 ) " ,  "I ( V2*V2*V3 ) " ,  "I ( V2*V2*V4 ) " ,  "I ( V2*V2*V8 ) " ,  "I ( V2*V2*V9 ) " ,  "I ( V2*V2*V17 ) " ,  "I ( V2*V2*V20 ) " ,  "I ( V2*V2*V21 ) " ,  "I ( V2*V2*V27 ) " ,  "I ( V2*V2*V29 ) " ,  "I ( V2*V3*V4 ) " ,  "I ( V2*V3*V8 ) " ,  "I ( V2*V3*V9 ) " ,  "I ( V2*V3*V17 ) " ,  "I ( V2*V3*V20 ) " ,  "I ( V2*V3*V21 ) " ,  "I ( V2*V3*V27 ) " ,  "I ( V2*V3*V29 ) " ,  "I ( V2*V4*V4 ) " ,  "I ( V2*V4*V8 ) " ,  "I ( V2*V4*V9 ) " ,  "I ( V2*V4*V17 ) " ,  "I ( V2*V4*V20 ) " ,  "I ( V2*V4*V21 ) " ,  "I ( V2*V4*V27 ) " ,  "I ( V2*V4*V29 ) " ,  "I ( V2*V8*V8 ) " ,  "I ( V2*V9*V9 ) " ,  "I ( V2*V9*V21 ) " ,  "I ( V2*V17*V17 ) " ,  "I ( V2*V20*V20 ) " ,  "I ( V2*V21*V21 ) " ,  "I ( V2*V21*V27 ) " ,  "I ( V2*V27*V27 ) " ,  "I ( V2*V29*V29 ) " ,  "I ( V3*V3*V3 ) " ,  "I ( V3*V3*V8 ) " ,  "I ( V3*V3*V9 ) " ,  "I ( V3*V3*V17 ) " ,  "I ( V3*V3*V20 ) " ,  "I ( V3*V3*V21 ) " ,  "I ( V3*V3*V27 ) " ,  "I ( V3*V3*V29 ) " ,  "I ( V3*V4*V8 ) " ,  "I ( V3*V4*V9 ) " ,  "I ( V3*V4*V17 ) " ,  "I ( V3*V4*V20 ) " ,  "I ( V3*V4*V21 ) " ,  "I ( V3*V4*V27 ) " ,  "I ( V3*V4*V29 ) " ,  "I ( V3*V8*V8 ) " ,  "I ( V3*V9*V9 ) " ,  "I ( V3*V9*V21 ) " ,  "I ( V3*V17*V17 ) " ,  "I ( V3*V19*V19 ) " ,  "I ( V3*V20*V20 ) " ,  "I ( V3*V21*V21 ) " ,  "I ( V3*V21*V27 ) " ,  "I ( V3*V27*V27 ) " ,  "I ( V3*V29*V29 ) " ,  "I ( V4*V4*V8 ) " ,  "I ( V4*V4*V9 ) " ,  "I ( V4*V4*V17 ) " ,  "I ( V4*V4*V20 ) " ,  "I ( V4*V4*V21 ) " ,  "I ( V4*V4*V27 ) " ,  "I ( V4*V4*V29 ) " ,  "I ( V4*V8*V8 ) " ,  "I ( V4*V9*V9 ) " ,  "I ( V4*V9*V21 ) " ,  "I ( V4*V17*V17 ) " ,  "I ( V4*V20*V20 ) " ,  "I ( V4*V21*V21 ) " ,  "I ( V4*V21*V27 ) " ,  "I ( V4*V27*V27 ) " ,  "I ( V4*V29*V29 ) " ,  "I ( V8*V8*V8 ) " ,  "I ( V9*V9*V9 ) " ,  "I ( V9*V9*V21 ) " ,  "I ( V9*V21*V21 ) " ,  "I ( V17*V17*V17 ) " ,  "I ( V19*V21*V27 ) " ,  "I ( V20*V20*V20 ) " ,  "I ( V21*V21*V21 ) " ,  "I ( V21*V21*V27 ) " ,  "I ( V21*V27*V27 ) " ,  "I ( V27*V27*V27 ) " ,  "I ( V29*V29*V29 ) " ,  "I ( V2*V12*V28 ) " ,  "I ( V4*V4*V26 ) " ,  "I ( V4*V19*V26 ) " ,  "I ( V1*V2*V15 ) " ,  "I ( V1*V15*V15 ) " ,  "I ( V4*V20*V21 ) " ,  "I ( V8*V8*V18 ) " ,  "I ( V8*V8*V21 ) " ,  "I ( V8*V18*V18 ) " ,  "I ( V8*V18*V19 ) " ,  "I ( V8*V18*V21 ) " ,  "I ( V8*V19*V21 ) " ,  "I ( V8*V21*V21 ) " ,  "I ( V9*V19*V21 ) " ,  "I ( V3*V11*V11 ) " ,  "I ( V4*V8*V19 ) " ,  "I ( V10*V10*V11 ) " ,  "I ( V10*V11*V11 ) " ,  "I ( V10*V11*V19 ) " ,  "I ( V4*V13*V13 ) " ,  "I ( V4*V12*V28 ) " ,  "I ( V4*V8*V18 ) " ,  "I ( V4*V8*V21 ) " ,  "I ( V2*V10*V11 ) " ,  "I ( V3*V13*V13 ) " ,  "I ( V1*V9*V18 ) " ,  "I ( V9*V9*V18 ) " ,  "I ( V9*V18*V18 ) " ,  "I ( V9*V18*V19 ) " ,  "I ( V9*V18*V21 ) " ,  "I ( V2*V4*V10 ) " ,  "I ( V2*V9*V18 ) " ,  "I ( V19*V19*V29 ) " ,  "I ( V19*V29*V29 ) " ,  "I ( V2*V19*V29 ) " ,  "I ( V3*V4*V12 ) " ,  "I ( V3*V10*V11 ) " ,  "I ( V4*V9*V18 ) " ,  "I ( V2*V8*V19 ) " ,  "I ( V1*V8*V19 ) " ,  "I ( V1*V20*V21 ) " ,  "I ( V1*V8*V18 ) " ,  "I ( V1*V8*V21 ) " ,  "I ( V2*V8*V18 ) " ,  "I ( V2*V8*V21 ) " ,  "I ( V12*V12*V28 ) " ,  "I ( V12*V28*V28 ) " ,  "I ( V1*V4*V15 ) " ,  "I ( V4*V19*V29 ) " ,  "I ( V3*V19*V29 ) " ,  "I ( V3*V8*V19 ) " ,  "I ( V1*V2*V16 ) " ,  "I ( V3*V4*V13 ) " ,  "I ( V3*V20*V21 ) " ,  "I ( V3*V8*V18 ) " ,  "I ( V3*V8*V21 ) " ,  "I ( V1*V3*V26 ) " ,  "I ( V13*V13*V13 ) " ,  "I ( V4*V19*V19 ) " ,  "I ( V3*V18*V18 ) " ,  "I ( V1*V25*V25 ) " ,  "I ( V2*V2*V18 ) " ,  "I ( V3*V21*V29 ) " ,  "I ( V4*V18*V19 ) " ,  "I ( V2*V4*V11 ) " ,  "I ( V1*V4*V22 ) " ,  "I ( V1*V1*V13 ) " ,  "I ( V3*V8*V12 ) " ,  "I ( V4*V19*V25 ) " ,  "I ( V1*V12*V28 ) " ,  "I ( V3*V3*V16 ) " ,  "I ( V1*V2*V23 ) " ,  "I ( V3*V4*V23 ) " ,  "I ( V1*V3*V10 ) " ,  "I ( V2*V3*V10 ) " ,  "I ( V2*V3*V15 ) " ,  "I ( V1*V1*V16 ) " ,  "I ( V3*V3*V22 ) " ,  "I ( V1*V9*V19 ) " ,  "I ( V1*V2*V14 ) " ,  "I ( V1*V1*V26 ) " ,  "I ( V1*V25*V29 ) " ,  "I ( V4*V19*V21 ) " ,  "I ( V4*V4*V10 ) " ,  "I ( V2*V4*V6 ) " ,  "I ( V3*V25*V29 ) " ,  "I ( V4*V4*V11 ) " ,  "I ( V3*V24*V24 ) " ,  "I ( V3*V4*V15 ) " ,  "I ( V1*V2*V12 ) " ,  "I ( V3*V3*V19 ) " ,  "I ( V1*V1*V4 ) " ,  "I ( V4*V7*V7 ) " ,  "I ( V1*V1*V24 ) " ,  "I ( V11*V11*V19 ) " ,  "I ( V11*V19*V19 ) " ,  "I ( V2*V4*V22 ) " ,  "I ( V4*V10*V19 ) " ,  "I ( V1*V23*V23 ) " ,  "I ( V3*V3*V11 ) " ,  "I ( V4*V4*V25 ) " ,  "I ( V2*V3*V14 ) " ,  "I ( V2*V23*V27 ) " ,  "I ( V26*V26*V26 ) " ,  "I ( V4*V22*V22 ) " ,  "I ( V3*V3*V12 ) " ,  "I ( V1*V2*V26 ) " ,  "I ( V2*V2*V25 ) " ,  "I ( V21*V21*V29 ) " ,  "I ( V21*V25*V29 ) " ,  "I ( V21*V29*V29 ) " ,  "I ( V3*V3*V4 ) " ,  "I ( V19*V19*V19 ) " ,  "I ( V2*V3*V18 ) " ,  "I ( V3*V3*V7 ) " ,  "I ( V3*V4*V6 ) " ,  "I ( V1*V18*V19 ) " ,  "I ( V1*V12*V12 ) " ,  "I ( V3*V4*V7 ) " ,  "I ( V4*V4*V22 ) " ,  "I ( V1*V3*V22 ) " ,  "I ( V18*V18*V19 ) " ,  "I ( V18*V19*V19 ) " ,  "I ( V3*V4*V14 ) " ,  "I ( V1*V3*V14 ) " ,  "I ( V12*V12*V12 ) " ,  "I ( V14*V14*V14 ) " ,  "I ( V3*V4*V18 ) " ,  "I ( V1*V3*V6 ) " ,  "I ( V3*V3*V15 ) " ,  "I ( V2*V2*V22 ) " ,  "I ( V3*V19*V26 ) " ,  "I ( V2*V3*V23 ) " ,  "I ( V3*V21*V25 ) " ,  "I ( V2*V2*V19 ) " ,  "I ( V1*V1*V22 ) " ,  "I ( V1*V3*V25 ) " ,  "I ( V22*V22*V22 ) " ,  "I ( V2*V7*V7 ) " ,  "I ( V1*V4*V10 ) " ,  "I ( V1*V1*V19 ) " ,  "I ( V19*V19*V26 ) " ,  "I ( V19*V26*V26 ) " ,  "I ( V2*V26*V26 ) " ,  "I ( V3*V3*V24 ) " ,  "I ( V3*V3*V14 ) " ,  "I ( V3*V4*V22 ) " ,  "I ( V4*V4*V19 ) " ,  "I ( V2*V11*V19 ) " ,  "I ( V1*V9*V20 ) " ,  "I ( V1*V1*V11 ) " ,  "I ( V2*V4*V23 ) " ,  "I ( V2*V4*V26 ) " ,  "I ( V2*V6*V6 ) " ,  "I ( V3*V3*V6 ) " ,  "I ( V3*V4*V19 ) " ,  "I ( V11*V11*V11 ) " ,  "I ( V2*V2*V15 ) " ,  "I ( V3*V19*V21 ) " ,  "I ( V4*V6*V6 ) " ,  "I ( V4*V4*V15 ) " ,  "I ( V1*V2*V22 ) " ,  "I ( V15*V15*V15 ) " ,  "I ( V3*V10*V19 ) " ,  "I ( V4*V4*V23 ) " ,  "I ( V24*V24*V24 ) " ,  "I ( V3*V4*V10 ) " ,  "I ( V2*V25*V29 ) " ,  "I ( V1*V3*V12 ) " ,  "I ( V3*V18*V21 ) " ,  "I ( V2*V4*V7 ) " ,  "I ( V1*V21*V29 ) " ,  "I ( V2*V2*V26 ) " ,  "I ( V1*V1*V12 ) " ,  "I ( V2*V4*V18 ) " ,  "I ( V3*V23*V27 ) " ,  "I ( V1*V11*V19 ) " ,  "I ( V4*V25*V25 ) " ,  "I ( V1*V4*V14 ) " ,  "I ( V2*V18*V18 ) " ,  "I ( V7*V7*V7 ) " ,  "I ( V2*V2*V7 ) " ,  "I ( V1*V22*V22 ) " ,  "I ( V4*V4*V6 ) " ,  "I ( V4*V26*V26 ) " ,  "I ( V3*V10*V10 ) " ,  "I ( V3*V4*V16 ) " ,  "I ( V4*V4*V7 ) " ,  "I ( V2*V3*V19 ) " ,  "I ( V2*V16*V16 ) " ,  "I ( V2*V2*V14 ) " ,  "I ( V2*V22*V22 ) " ,  "I ( V1*V3*V18 ) " ,  "I ( V3*V4*V11 ) " ,  "I ( V2*V9*V19 ) " ,  "I ( V3*V15*V15 ) " ,  "I ( V1*V1*V6 ) " ,  "I ( V2*V9*V20 ) " ,  "I ( V2*V19*V25 ) " ,  "I ( V2*V3*V16 ) " ,  "I ( V4*V21*V29 ) " ,  "I ( V3*V11*V19 ) " ,  "I ( V1*V1*V7 ) " ,  "I ( V8*V8*V12 ) " ,  "I ( V8*V12*V12 ) " ,  "I ( V2*V8*V12 ) " ,  "I ( V2*V24*V24 ) " ,  "I ( V4*V21*V25 ) " ,  "I ( V10*V10*V19 ) " ,  "I ( V10*V19*V19 ) " ,  "I ( V2*V4*V15 ) " ,  "I ( V1*V2*V18 ) " ,  "I ( V2*V19*V21 ) " ,  "I ( V2*V10*V10 ) " ,  "I ( V4*V25*V29 ) " ,  "I ( V1*V1*V23 ) " ,  "I ( V23*V23*V23 ) " ,  "I ( V2*V21*V29 ) " ,  "I ( V3*V23*V23 ) " ,  "I ( V1*V3*V11 ) " ,  "I ( V19*V21*V25 ) " ,  "I ( V1*V26*V26 ) " ,  "I ( V1*V4*V12 ) " ,  "I ( V4*V19*V27 ) " ,  "I ( V3*V16*V16 ) " ,  "I ( V3*V3*V10 ) " ,  "I ( V2*V3*V25 ) " ,  "I ( V1*V1*V15 ) " ,  "I ( V2*V19*V19 ) " ,  "I ( V2*V23*V23 ) " ,  "I ( V1*V19*V25 ) " ,  "I ( V3*V9*V20 ) " ,  "I ( V2*V18*V19 ) " ,  "I ( V2*V2*V6 ) " ,  "I ( V16*V16*V16 ) " ,  "I ( V1*V1*V14 ) " ,  "I ( V2*V2*V11 ) " ,  "I ( V3*V7*V7 ) " ,  "I ( V3*V6*V6 ) " ,  "I ( V1*V21*V25 ) " ,  "I ( V3*V4*V24 ) " ,  "I ( V2*V25*V25 ) " ,  "I ( V2*V3*V24 ) " ,  "I ( V1*V19*V21 ) " ,  "I ( V1*V1*V25 ) " ,  "I ( V3*V18*V19 ) " ,  "I ( V4*V14*V14 ) " ,  "I ( V3*V4*V25 ) " ,  "I ( V4*V11*V11 ) " ,  "I ( V4*V15*V15 ) " ,  "I ( V2*V15*V15 ) " ,  "I ( V4*V16*V16 ) " ,  "I ( V1*V2*V6 ) " ,  "I ( V2*V4*V25 ) " ,  "I ( V3*V12*V12 ) " ,  "I ( V3*V9*V19 ) " ,  "I ( V2*V3*V7 ) " ,  "I ( V3*V14*V14 ) " ,  "I ( V1*V2*V19 ) " ,  "I ( V2*V11*V11 ) " ,  "I ( V4*V4*V24 ) " ,  "I ( V2*V19*V27 ) " ,  "I ( V2*V2*V24 ) " ,  "I ( V1*V2*V25 ) " ,  "I ( V2*V4*V14 ) " ,  "I ( V4*V11*V19 ) " ,  "I ( V2*V18*V21 ) " ,  "I ( V6*V6*V6 ) " ,  "I ( V2*V4*V16 ) " ,  "I ( V1*V23*V27 ) " ,  "I ( V23*V23*V27 ) " ,  "I ( V23*V27*V27 ) " ,  "I ( V4*V10*V10 ) " ,  "I ( V25*V25*V25 ) " ,  "I ( V4*V4*V16 ) " ,  "I ( V2*V3*V26 ) " ,  "I ( V4*V24*V24 ) " ,  "I ( V10*V10*V10 ) " ,  "I ( V1*V10*V19 ) " ,  "I ( V2*V2*V16 ) " ,  "I ( V3*V4*V4 ) " ,  "I ( V9*V20*V21 ) " ,  "I ( V20*V20*V21 ) " ,  "I ( V20*V21*V21 ) " ,  "I ( V4*V4*V14 ) " ,  "I ( V1*V4*V6 ) " ,  "I ( V2*V10*V19 ) " ,  "I ( V2*V20*V21 ) " ,  "I ( V18*V19*V21 ) " ,  "I ( V4*V9*V19 ) " ,  "I ( V2*V21*V25 ) " ,  "I ( V19*V19*V21 ) " ,  "I ( V19*V21*V21 ) " ,  "I ( V4*V23*V23 ) " ,  "I ( V9*V9*V20 ) " ,  "I ( V9*V20*V20 ) " ,  "I ( V2*V3*V22 ) " ,  "I ( V19*V19*V25 ) " ,  "I ( V19*V25*V25 ) " ,  "I ( V4*V23*V27 ) " ,  "I ( V21*V21*V25 ) " ,  "I ( V21*V25*V25 ) " ,  "I ( V9*V9*V19 ) " ,  "I ( V9*V19*V19 ) " ,  "I ( V2*V14*V14 ) " ,  "I ( V1*V2*V10 ) " ,  "I ( V3*V3*V23 ) " ,  "I ( V1*V10*V10 ) " ,  "I ( V4*V4*V4 ) " ,  "I ( V2*V2*V2 ) " ,  "I ( V4*V9*V20 ) " ,  "I ( V1*V6*V6 ) " ,  "I ( V8*V8*V19 ) " ,  "I ( V8*V19*V19 ) " ,  "I ( V2*V3*V6 ) " ,  "I ( V4*V8*V12 ) " ,  "I ( V2*V4*V24 ) " ,  "I ( V3*V19*V25 ) " ,  "I ( V3*V25*V25 ) " ,  "I ( V1*V3*V23 ) " ,  "I ( V1*V4*V26 ) " ,  "I ( V3*V3*V18 ) " ,  "I ( V1*V1*V10 ) " ,  "I ( V3*V22*V22 ) " ,  "I ( V25*V25*V29 ) " ,  "I ( V25*V29*V29 ) " ,  "I ( V1*V14*V14 ) " ,  "I ( V1*V4*V25 ) " ,  "I ( V1*V4*V23 ) " )

all.features.col <- c(train.col)
# all.features.col <- c(train.col,two.features.col)

#然后获得一般线性模型结果
fmla <- as.formula(paste(all.features.col[CLASS.INDEX], "~",paste(all.features.col[-CLASS.INDEX], collapse= "+")))

a <- nnet(fmla,new.train.feature,size=9,rang=0.03,decay=5e-4,maxit=100,MaxNWts=9999999)

test.feature <- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",")
# test.feature <- read.table(paste(BASE.PATH,"tef",sep=""),sep=",")
p=predict(a,test.feature[-CLASS.INDEX])

write.table(p,paste(BASE.PATH,"nnetPredictTest",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

m=prediction(p,test.feature[CLASS.INDEX])
png("nnetROC.png")
plot(performance(m,'tpr','fpr'))
abline(0,1, lty = 8, col = "grey")
dev.off()

# 另一个相关的衡量标准就是ROC图的曲线下面积，
# 许多的数据挖掘大赛会用它来作为最终的评价指标
auc <- performance(m, "auc")
auc@y.values
write.table(data.frame(auc@y.values),paste(BASE.PATH,"nnetAUC",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

#calc time cost
end.time <- Sys.time()
write.table(data.frame(end.time-start.time),paste(BASE.PATH,"nnetTime",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

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