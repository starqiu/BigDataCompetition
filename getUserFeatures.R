BASE.PATH <- "/host/kp/siat/KDD/ccf_contest/user_matrix/"

load.data <- function(){
  user.and.ad <<- read.table(paste(BASE.PATH,"usr_ads",sep=""),sep="\t")
  user <<- read.table(paste(BASE.PATH,"users.txt",sep=""),sep=",")
  ad <<- read.table(paste(BASE.PATH,"ads.txt",sep=""),sep="\t",header=TRUE)
  c <-3
}
 load.data()

demo()