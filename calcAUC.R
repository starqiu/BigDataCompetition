library(ROCR)
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"
p <- read.table(paste(BASE.PATH,"predict_rbf.txt",sep=""))
# test.feature <- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",")
# samp <-  1:2731704
# samp <-samp*2
# rp <- p[samp,1]
# write.table(test.feature[,30],paste(BASE.PATH,"TestingClassIndex",sep=""),sep="\t",
#             quote = FALSE,row.names = FALSE,col.names=FALSE)

test.class.index <- read.table(paste(BASE.PATH,"TestingClassIndex",sep=""))
m=prediction(p,test.class.index)
# png("ROC.png")
# plot(performance(m,'tpr','fpr'))
# abline(0,1, lty = 8, col = "grey")
# dev.off()

# 另一个相关的衡量标准就是ROC图的曲线下面积，
# 许多的数据挖掘大赛会用它来作为最终的评价指标

auc <- performance(m, "auc")
write.table(data.frame(auc@y.values),paste(BASE.PATH,"AUC",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
