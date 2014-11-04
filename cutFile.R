

init.env <-function(){
  BASE.PATH <<- "/home/xqiu/kdd/data/"
  SAVE.BASE.PATH <<- "/home/xqiu/kdd/data/combineModel/"
  
#   BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/"
#   SAVE.BASE.PATH <<- "/host/kp/siat/KDD/ccf_contest/um/combineModel/"
  
  MALE.REMOVE.INDEX <<-c(1,9,17,18,22,23,24,25,30)
  FEMALE.REMOVE.INDEX <<-c(1,9,10,19,20,21,29,31)

}
  
get.small.sample <-function(train.feature,test.feature){
  train.samp <- sort(sample(nrow(train.feature),100000))
  test.samp <- sort(sample(nrow(test.feature),10000))
  
  write.table(train.feature[train.samp,],paste(SAVE.BASE.PATH,"trf",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(test.feature[test.samp,],paste(SAVE.BASE.PATH,"tef",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}

cut.file.via.sex <-function(){
  
  USER.INDEX.IN.SAMPLE <- 1
  SEX.INDEX <- 3
  #new column count
  OFFSET <- 2  
  
  train.feature <- read.table(paste(BASE.PATH,"TrainingFeatures",sep=""),sep=",")
  test.feature <- read.table(paste(BASE.PATH,"TestingFeatures",sep=""),sep=",") 
  #   train.feature <- read.table(paste(BASE.PATH,"trf",sep=""),sep=",")
#     test.feature <- read.table(paste(BASE.PATH,"tef",sep=""),sep=",") 
  #   get.small.sample(train.feature,test.feature)
  
#   add row NO. and user id for train features
  train <- read.table(paste(BASE.PATH,"training.txt",sep=""),sep=",")
  train.length <- nrow(train.feature)
  train.row.no <- c(1:train.length)
  train.row.no.and.user <- cbind(train.row.no,train[,USER.INDEX.IN.SAMPLE])
  train.feature <- cbind(train.row.no.and.user,train.feature)
  write.table(train.feature[which(train.feature[SEX.INDEX]==1),-(MALE.REMOVE.INDEX+OFFSET)],
              paste(SAVE.BASE.PATH,"TrainingFeatures_m",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(train.feature[which(train.feature[SEX.INDEX]==-1),-(FEMALE.REMOVE.INDEX+OFFSET)],
              paste(SAVE.BASE.PATH,"TrainingFeatures_f",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  
  #add row NO.and user id  for test features
  test <- read.table(paste(BASE.PATH,"testing.txt",sep=""),sep=",") 
  test.length <- nrow(test.feature)
  test.row.no <- c(1:test.length)
  test.row.no.and.user <- cbind(test.row.no,test[,USER.INDEX.IN.SAMPLE])
  test.feature <- cbind(test.row.no.and.user,test.feature)
  t.m <-test.feature[which(test.feature[SEX.INDEX]==1),-(MALE.REMOVE.INDEX+OFFSET)]
  write.table(t.m,
              paste(SAVE.BASE.PATH,"TestingFeatures_m",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(test.feature[which(test.feature[SEX.INDEX]==-1),-(FEMALE.REMOVE.INDEX+OFFSET)],
              paste(SAVE.BASE.PATH,"TestingFeatures_f",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
#   
  rm(train.feature)
  rm(test.feature)
}


get.common.user.diff.by.sex <- function(){
  USER.INDEX <- 2
  ROW.NO.INDEX <- 1
  
  train.male <- read.table(paste(SAVE.BASE.PATH,"TrainingFeatures_m",sep=""),sep=",")
  train.female <- read.table(paste(SAVE.BASE.PATH,"TrainingFeatures_f",sep=""),sep=",")
  test.male <- read.table(paste(SAVE.BASE.PATH,"TestingFeatures_m",sep=""),sep=",")
  test.female <- read.table(paste(SAVE.BASE.PATH,"TestingFeatures_f",sep=""),sep=",")
  
  #   train.male.user <- read.table(paste(SAVE.BASE.PATH,"trainMaleUser",sep=""),sep=",")
  #   train.female.user <- read.table(paste(SAVE.BASE.PATH,"trainFeMaleUser",sep=""),sep=",")
  #   test.male.user <- read.table(paste(SAVE.BASE.PATH,"testMaleUser",sep=""),sep=",")
  #   test.female.user <- read.table(paste(SAVE.BASE.PATH,"testFeMaleUser",sep=""),sep=",")
  
  male.comm <- intersect(train.male[,USER.INDEX],test.male[,USER.INDEX])
  female.comm <- intersect(train.female[,USER.INDEX],test.female[,USER.INDEX])
  # male.comm <- read.table(paste(SAVE.BASE.PATH,"maleComm",sep=""),sep=",")[,1]
  # female.comm <- read.table(paste(SAVE.BASE.PATH,"femaleComm",sep=""),sep=",")[,1]
  
  train.male.comm <- train.male[which(train.male[,USER.INDEX] %in% male.comm),]
  train.female.comm <- train.female[which(train.female[,USER.INDEX] %in% female.comm),]
  test.male.comm <- test.male[which(test.male[,USER.INDEX] %in% male.comm),]
  test.female.comm <- test.female[which(test.female[,USER.INDEX] %in% female.comm),]
  test.male.diff <- test.male[-which(test.male[,USER.INDEX] %in% male.comm),]
  test.female.diff <- test.female[-which(test.female[,USER.INDEX] %in% female.comm),]
  
  write.table(male.comm,paste(SAVE.BASE.PATH,"maleComm",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(female.comm,paste(SAVE.BASE.PATH,"femaleComm",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  
  write.table(train.male.comm,paste(SAVE.BASE.PATH,"trainMaleComm",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(train.female.comm,paste(SAVE.BASE.PATH,"trainFemaleComm",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(test.male.comm,paste(SAVE.BASE.PATH,"testMaleComm",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(test.female.comm,paste(SAVE.BASE.PATH,"testFemaleComm",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(test.male.diff,paste(SAVE.BASE.PATH,"testMaleDiff",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
  write.table(test.female.diff,paste(SAVE.BASE.PATH,"testFemaleDiff",sep=""),sep=",",
              quote = FALSE,row.names = FALSE,col.names=FALSE)
}

stat.comm.record <-function(){
  
  
}

init.env() 
# cut.file.via.sex()
# get.common.user.diff.by.sex() 




print("succ")


main <- function(){
  init.env() 
  cut.file.via.sex()
  get.common.user.diff.by.sex() 

}


