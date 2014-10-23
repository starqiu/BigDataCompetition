CLASSIFY.PATH <- "/host/kp/siat/KDD/ccf_contest/classify/"
AD.PATH <- "/host/kp/siat/KDD/ccf_contest/data/ad.txt"
OUTPUT.PATH <- "/host/kp/siat/KDD/ccf_contest/ads.txt"

dirs <- list.files(CLASSIFY.PATH)
ads <- read.table(AD.PATH,sep=",",col.names = c("AdID","title","creativeID"))
old.colnames <- colnames(ads)

for(dir in dirs){
#   print(dir)
  spec.dir.path <- paste(CLASSIFY.PATH ,dir,sep ="")
  flies <- list.files(spec.dir.path)
  files.no.suffix.name <- sub(".jpg","",flies,fixed = TRUE)
#   write.table(files.no.suffix.name,file=paste(spec.dir.path,"_ids",sep=""),
#              quote = FALSE,row.names = FALSE,col.names = FALSE)
  new.col <- ads[,3]
  new.col[!new.col %in%  files.no.suffix.name] <- 0
  new.col[new.col %in%  files.no.suffix.name] <- 1
  ads <- cbind(ads,new.col)
}
colnames(ads) <- c(old.colnames,dirs)

write.table(ads,file= OUTPUT.PATH,sep="\t",
           quote = FALSE,row.names = FALSE)
