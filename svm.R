library(e1071)
library(ROCR)

BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"
CLASS.INDEX <- 30

start.time <- Sys.time()
train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
num <- nrow(train.feature)
set.seed(2)
samp <- sort(sample(num,10000))
train.col <- colnames(train.feature,prefix="")
#然后获得一般线性模型结果
fmla <- as.formula(paste(train.col[CLASS.INDEX], "~",paste(train.col[-CLASS.INDEX], collapse= "+")))

# a <- svm(fmla,train.feature[samp,])
a <- svm(fmla,train.feature)

test.feature <- read.table(paste(BASE.PATH,"tef",sep=""),sep=",")
p=predict(a,test.feature[-CLASS.INDEX])

write.table(p,paste(BASE.PATH,"svmPredictTest",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

m=prediction(p,test.feature[CLASS.INDEX])
png("svmROC.png")
plot(performance(m,'tpr','fpr'))
abline(0,1, lty = 8, col = "grey")
dev.off()

# 另一个相关的衡量标准就是ROC图的曲线下面积，
# 许多的数据挖掘大赛会用它来作为最终的评价指标
auc <- performance(m, "auc")
write.table(data.frame(auc@y.values),paste(BASE.PATH,"svmAUC",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
#calc time cost
end.time <- Sys.time()

write.table(data.frame(end.time-start.time),paste(BASE.PATH,"svmTime",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)