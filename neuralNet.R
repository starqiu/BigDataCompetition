library(ROCR)
library(nnet)
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"

start.time <- Sys.time()
train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
num <- nrow(train.feature)
set.seed(1)
samp <- sort(sample(num,10000))
train.col <- colnames(train.feature,prefix="")
#然后获得一般线性模型结果
fmla <- as.formula(paste(train.col[30], "~",paste(train.col[-30], collapse= "+")))

a <- nnet(fmla,train.feature[samp,],size=9,rang=0.03,decay=5e-4,maxit=1000)

test.feature <- read.table(paste(BASE.PATH,"tef",sep=""),sep=",")
p=predict(a,test.feature[-30])

write.table(p,paste(BASE.PATH,"nnetPredictTest",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

m=prediction(p,test.feature[30])
png("nnetROC.png")
plot(performance(m,'tpr','fpr'))
abline(0,1, lty = 8, col = "grey")
dev.off()

# 另一个相关的衡量标准就是ROC图的曲线下面积，
# 许多的数据挖掘大赛会用它来作为最终的评价指标

auc <- performance(m, "auc")
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