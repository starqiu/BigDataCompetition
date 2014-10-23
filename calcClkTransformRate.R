BASE.PATH <- "/host/kp/siat/KDD/data/merge/"

clicked  <- read.table(paste(BASE.PATH,"userAndDatesClicked/part-r-00000",sep=""),
                             header=TRUE,sep="")
transformed<- read.table(paste(BASE.PATH,"userAndDatesTransformed/part-r-00000",sep=""),
                          header=TRUE,sep="")

clicked.transform <-intersect(clicked[,1],transformed[,1])

print(length(clicked.transform)/length(clicked[,1]))
print(length(clicked.transform)/length(transformed[,1]))

write.table(as.data.frame(clicked.transform),
            paste(BASE.PATH,"clickedTransform",sep=""),
            row.names=FALSE,
            col.names=FALSE,
            quote = FALSE,
            sep="\t")