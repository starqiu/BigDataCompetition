BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/um/"

train <- read.table(paste(BASE.PATH,"train",sep=""),sep=",")
train <- train[,c(-3,-4)]
num <- nrow(train)
set.seed(1)
samp <- sort(sample(num,10))
simp.train <- train[samp,]
simp.train[2,1] <-16119671
simp.train[4,2] <-7227017