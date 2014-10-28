library(caret)

CLASS.INDEX <- 30
BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"

train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
test.feature <- read.table(paste(BASE.PATH,"tef",sep=""),sep=",")
# test.desc <- test.feature[-CLASS.INDEX]
# test.class <- test.feature[CLASS.INDEX]
# rm(test.feature)
# zerovar <- nearZeroVar(test.desc)
# newdata1 <- test.desc[,-zerovar]
# rm(test.desc)
# 再删去相关度过高的自变量
descrCorr <- cor(train.feature)
highCorr <- findCorrelation(descrCorr, 0.90)
write.table(p,paste(BASE.PATH,"trainHighCorr",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

descrCorr <- cor(test.feature)
highCorr <- findCorrelation(descrCorr, 0.90)
write.table(p,paste(BASE.PATH,"testHighCorr",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

write.table(s,paste(BASE.PATH,"trainSummary",sep=""),sep="\t",
            quote = FALSE,row.names = FALSE,col.names=FALSE)

# if(length(highCorr)!=0){
#   newdata2 <<- test.feature[, -highCorr]
# }else{
#   newdata2 <<- test.feature
# }
# 
# # 数据预处理步骤（标准化，缺失值处理）
# Process <- preProcess(newdata2)
# newdata3 <- predict(Process, newdata2)
# # 用sbf函数实施过滤方法，这里是用随机森林来评价变量的重要性
# data.filter <- sbf(newdata3,test.class,
#                    sbfControl = sbfControl(functions=rfSBF,
#                                            verbose=F,
#                                            method='cv'))
# # 根据上面的过滤器筛选出67个变量
# x <- newdata3[data.filter$optVariables]
# # 再用rfe函数实施封装方法，建立的模型仍是随机森林
# profile <- rfe(x,test.class,
#                sizes = c(10,20,30,50,60),
#                rfeControl = rfeControl(functions=rfFuncs
#                                        ,method='cv'))
# # 将结果绘图，发现20-30个变量的模型精度最高
# plot(profile,type=c('o','g'))