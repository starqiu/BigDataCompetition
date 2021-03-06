library(ROCR)
BASE.PATH <- "/home/xqiu/kdd/data/"
REMOVE.FEATRUE.INDEX <-c(5,28)

start.time <- Sys.time()
train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
CLASS.INDEX <-  ncol(train.feature)
train.col <- colnames(train.feature,prefix="")
#然后获得一般线性模型结果
fmla <- as.formula(paste(train.col[CLASS.INDEX], "~",paste(train.col[-CLASS.INDEX], collapse= "+")))
glm.sol<-glm(fmla, family=binomial, data=train.feature)
# summary(glm.sol)
write.table(glm.sol$coefficients,paste(BASE.PATH,"coefficients",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)
#根据模型对 测试集做预测，得到为正样本的概率

test.feature <- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",")
pre<-predict(glm.sol, test.feature[-CLASS.INDEX])
p<-1/(1+exp(-pre))
write.table(p,paste(BASE.PATH,"lrPredictTest",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)


# 若要检测模型预测能力，可以利用ROC图来进行观察
# 首先用原数据代入模型得出预测概率，严格来讲训练和检测需要用不同的样本，
# 这里暂时不考虑。
# pre=predict(glm.sol,type='response')

# 再利用ROCR包绘制ROC图以衡量模型的效果。

m=prediction(p,test.feature[CLASS.INDEX])
png("lrROC.png")
plot(performance(m,'tpr','fpr'))
abline(0,1, lty = 8, col = "grey")
dev.off()

# 另一个相关的衡量标准就是ROC图的曲线下面积，
# 许多的数据挖掘大赛会用它来作为最终的评价指标

auc <- performance(m, "auc")
auc@y.values
write.table(data.frame(auc@y.values),paste(BASE.PATH,"lrAUC",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

#calc time cost
end.time <- Sys.time()
write.table(data.frame(end.time-start.time),paste(BASE.PATH,"lrTime",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

#simple data test
# life = data.frame(
#   X1=c(2.5, 173, 119, 10, 502, 4, 14.4, 2, 40, 6.6,21.4, 2.8, 2.5, 6, 3.5, 62.2, 10.8, 21.6, 2, 3.4,5.1, 2.4, 1.7, 1.1, 12.8, 1.2, 3.5, 39.7, 62.4, 2.4,34.7, 28.4, 0.9, CLASS.INDEX.6, 5.8, 6.1, 2.7, 4.7, 128, 35,2, 8.5, 2, 2, 4.3, 244.8, 4, 5.1, 32, 1.4),
#   X2=rep(c(0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2,0, 2, 0, 2, 0, 2, 0),
#          c(1, 4, 2, 2, 1, 1, 8, 1, 5, 1, 5, 1, 1, 1, 2, 1,1, 1, 3, 1, 2, 1, 4)),
#   X3=rep(c(0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1),
#          c(6, 1, 3, 1, 3, 1, 1, 5, 1, 3, 7, 1, 1, 3, 1, 1, 2, 9)),
#   Y=rep(c(0,  1,   0,  1), c(15, 10, 15, 10))
# )
# 
# glm.sol<-glm(Y~X1+X2+X3, family=binomial, data=life)
# summary(glm.sol)
# 
# pre<-predict(glm.sol, data.frame(X1=5,X2=2,X3=1))
# p<-exp(pre)/(1+exp(pre))
# 
# pre=predict(glm.sol,type='response')
# library(ROCR)
# m=prediction(pre,life$Y)
# plot(performance(m,'tpr','fpr'))
# abline(0,1, lty = 8, col = "grey")
# auc <- performance(m, "auc")
