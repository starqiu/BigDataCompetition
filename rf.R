library(randomForest)
library(foreach)
library(doParallel)
library(ROCR)

train <- read.csv("~/TencentBigData/NewFeatures/TrainingFeatures", header = F)
test <- read.csv("~/TencentBigData/NewFeatures/TestingFeatures", header = F)

train_1 <- subset(train, train$V32 == 1)
train_0 <- subset(train, train$V32 == 0)
s <- sample.int(nrow(train_0), size = 2*nrow(train_1))
train_0 <- train_0[s,]

train <- rbind(train_1, train_0)

x <- train[, 1:(ncol(train)-1)]
y <- as.factor(as.character(train[, ncol(train)]))

#x <- train[1:10000, 1:(ncol(train)-1)]
#y <- as.factor(as.character(train[1:10000, ncol(train)]))


cl <- makePSOCKcluster(10)
registerDoParallel(cl)
rf <- foreach(ntree = rep(50, 10), .combine = 'combine', .packages = 'randomForest') %dopar%{
  randomForest(x, y, ntree = ntree)
}

prob <- predict(rf, test[,1:(ncol(test)-1)], type = "prob")

save(prob, file = "pred.RData")

pred <- prediction(prob[,2], test[,ncol(test)])

auc <- performance(pred, "auc")

print(auc@y.values)

