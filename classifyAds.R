BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/"

ads.in.train <- read.table(paste(BASE.PATH,"adrate",sep=""),
                            header=FALSE,sep=",")
ads.in.test <- read.table(paste(BASE.PATH,"data/testing.txt",sep=""),
                          header=FALSE,sep=",")

new.ads.in.test <- setdiff(t(ads.in.test)[2,],t(ads.in.train)[1,])
old.ads.in.test <- intersect(t(ads.in.test)[2,],t(ads.in.train)[1,])

print(paste("numbers of new.ads.in.test:",length(new.ads.in.test)))
print(paste("numbers of old.ads.in.test:",length(old.ads.in.test)))

write.table(as.data.frame(new.ads.in.test),
            paste(BASE.PATH,"newAdsIntest",sep=""),
            row.names=FALSE,
            col.names=FALSE,
            quote = FALSE,
            sep="\t")
write.table(as.data.frame(old.ads.in.test),
            paste(BASE.PATH,"oldAdsInTest",sep=""),
            row.names=FALSE,
            col.names=FALSE,
            quote = FALSE,
            sep="\t")