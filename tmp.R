# ex1 <- function(ep,d,N){
#   ep^2*(1-(d+1)/N)
# }
# 
# print(ex1(0.1,8,10))
# print(ex1(0.1,8,100))
# print(ex1(0.1,8,1000))
# print(ex1(0.1,8,25))
# print(ex1(0.1,8,500))

# E <- function(u,v){
#   exp(u) + exp(2*v) + exp(u*v) + u^2 -2*u*v +2*(v^2) -3*u -2*v
# }
# E_fun <- expression(exp(u) + exp(2*v) + exp(u*v) + u^2 -2*u*v +2*(v^2) -3*u -2*v)
# 
# u <-0
# v <-0
# uv <- c(0,0)
# for (i in 1:5){
#   #D()函数可以用来对函数求导函数
#   err = c(eval(D(E_fun,"u")),eval(D(E_fun,"v")))
#   uv <- uv - 0.01 * err
#   u <- uv[1]
#   v <- uv[2]
# }
# 
# res <- E(u,v)

X <- matrix(runif(1000*2,-1,1),1000,2)
samp.num <-100
X[1:samp.num,] <- -X[1:samp.num,]