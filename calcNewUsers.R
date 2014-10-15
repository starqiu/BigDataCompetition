BASE.PATH <- "/host/kp/siat/KDD/data/"

users.in.train <- read.table(paste(BASE.PATH,"usersInTrain/part-r-00000",sep=""),
                           header=TRUE,sep="")
users.in.test <- read.table(paste(BASE.PATH,"usersInTest/part-r-00000",sep=""),
                             header=TRUE,sep="")
users.in.validation <- read.table(paste(BASE.PATH,"usersInValidation/part-r-00000",sep=""),
                             header=TRUE,sep="")

#users.in.train <- t(users.in.train)[1,]
# users.in.test <- t(users.in.test)[1,]
# users.in.validation <- t(users.in.validation)[1,]

new.users.in.test <-setdiff(users.in.test[,1],users.in.train[,1])
new.users.in.validation <-setdiff(users.in.validation[,1],users.in.train[,1])
new.test.users.in.validation <-setdiff(users.in.test[,1],users.in.validation[,1])

write.table(as.data.frame(new.users.in.test),
            paste(BASE.PATH,"newUsersInTest",sep=""),
            row.names=FALSE,
            col.names=FALSE,
            quote = FALSE,
            sep="\t")
write.table(as.data.frame(new.users.in.validation),
            paste(BASE.PATH,"newUsersInValidation",sep=""),
            row.names=FALSE,
            col.names=FALSE,
            quote = FALSE,
            sep="\t")
new.user.rate.in.test<-length(new.users.in.test)/length(users.in.test[,1])
new.user.rate.in.validation<-length(new.users.in.validation)/length(users.in.validation[,1])

print(new.user.rate.in.test)
print(new.user.rate.in.validation)

