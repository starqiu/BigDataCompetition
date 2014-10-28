library(ROCR)
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/"

# p1 <- read.table(paste(BASE.PATH,"LogistRegression/predictTest",sep=""))[,1]
# auc1 <- read.table(paste(BASE.PATH,"LogistRegression/auc",sep=""))[1,1]
# 
# p2 <- read.table(paste(BASE.PATH,"NeuralNet/nnetPredictTest",sep=""))[,1]
# auc2 <- read.table(paste(BASE.PATH,"NeuralNet/nnetAUC",sep=""))[1,1]

# p3 <- read.table(paste(BASE.PATH,"um/predict_rbf.txt",sep=""))[,1]
p <- (p1*auc1+p2*auc2+p3*0.7085)/(auc1+auc2+0.7085)
# p <- (p1+p2+p3)/3
# write.table(p,paste(BASE.PATH,"um/combineModelPredictTest",sep=""),sep="\t",
#             quote = FALSE,row.names = FALSE,col.names=FALSE)

# test.class.index <- read.table(paste(BASE.PATH,"um/TestingClassIndex",sep=""))
m=prediction(p,test.class.index)

auc <- performance(m, "auc")
write.table(data.frame(auc@y.values),paste(BASE.PATH,"um/combineModelAUC",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)