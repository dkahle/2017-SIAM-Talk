setwd("/Users/david_kahle/Dropbox/Baylor University/Employment/Conferences/SIAM/2017/2017 SIAM Talk")


##### installing stuff
########################################

if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/mpoly", ref = "670645f")
devtools::install_github("dkahle/latter", ref = "9d2fd27")
devtools::install_github("dkahle/tropical", ref = "5599df2")
devtools::install_github("coneill-math/m2r", ref = "572aadd")
devtools::install_github("dkahle/algstat", ref = "1f063ab")


##### mpoly
########################################

(x <- c(1, 2, 3)) # a vector
# [1] 1 2 3
(y <- list(1:3, c("a","b"), TRUE)) # a list
# [[1]]
# [1] 1 2 3
# 
# [[2]]
# [1] "a" "b"
# 
# [[3]]
# [1] TRUE
# 

attr(x, "names") <- c("x", "y", "z")
x
# x y z 
# 1 2 3 

attr(x, "class") <- "foo"
x
# x y z 
# 1 2 3 
# attr(,"class")
# [1] "foo"

print(x)
# x y z 
# 1 2 3 
# attr(,"class")
# [1] "foo"

print.foo <- function(.) {
  cat( paste0(names(.), "^", .) )
}
x
# x^1 y^2 z^3

str(x)
# Class 'foo'  Named num [1:3] 1 2 3
#   ..- attr(*, "names")= chr [1:3] "x" "y" "z"

library(mpoly)
mp("x^2 + 2 x y - 1")
# x^2  +  2 x y  -  1

str( mp("x^2 + 2 x y - 1") ) 
# List of 3
#  $ : Named num [1:2] 2 1
#   ..- attr(*, "names")= chr [1:2] "x" "coef"
#  $ : Named num [1:3] 1 1 2
#   ..- attr(*, "names")= chr [1:3] "x" "y" "coef"
#  $ : Named num -1
#   ..- attr(*, "names")= chr "coef"
#  - attr(*, "class")= chr "mpoly"

p <- mp("x + y"); q <- mp("x - y")
p + q
# 2 x
p * q
# x^2  -  y^2
p^2
# x^2  +  2 x y  +  y^2

f <- as.function(p, vector = FALSE)
# f(x, y)
f(1, 2)
# [1] 3

(ps <- mp(c("x + y", "x - y^2")))
# x  +  y
# x  -  y^2

g <- as.function(ps)




##### latte
########################################

library(latter)
#  LattE found in /Applications/latte/dest/bin
#  4ti2 found in /Applications/latte/dest/bin

(A <- genmodel(c(2, 2), 1:2)) # 2x2 independence model
#      [,1] [,2] [,3] [,4]
# [1,]    1    0    1    0
# [2,]    0    1    0    1
# [3,]    1    1    0    0
# [4,]    0    0    1    1

markov(A)
#      [,1]
# [1,]    1
# [2,]   -1
# [3,]   -1
# [4,]    1

graver(A)
#      [,1]
# [1,]    1
# [2,]   -1
# [3,]   -1
# [4,]    1


spec <- c("x + y <= 10", "x >= 1", "y >= 1")
count(spec)
# [1] 45
count(spec, dilation = 10)
# [1] 3321

latte_max(
  "-2 x + 3 y", 
  c("x + y <= 10", "x >= 0", "y >= 0")
)
# $par
#  x  y 
#  0 10 
# 
# $value
# [1] 30


##### bertini 
########################################

library(algstat)
polySolve(c("y == x^2", "y == 2 - x^2"), varOrder = c("x", "y"))
# 2 solutions (x,y) found.  (2 real, 0 complex; 2 nonsingular, 0 singular.)
#     (-1,1) (R)
#     ( 1,1) (R)

##### tropical
########################################

library(tropical)
# Using min-plus algebra.

# basic tropical arithmetic
1 %+% 5
# [1] 1
1 %.% 5
# [1] 6
5 %^% 3
# [1] 15

# vectorized for R-users
1:3 %+% 3:1
# [1] 1 2 1
1:3 %.% 3:1
# [1] 4 4 4

# tropical inner product
1:3 %..% 4:6
# [1] 5

# tropical mat. mult.
(m1 <- matrix(1:6, 2, 3))
#      [,1] [,2] [,3]
# [1,]    1    3    5
# [2,]    2    4    6
(m2 <- matrix(6:1, 3, 2))
#      [,1] [,2]
# [1,]    6    3
# [2,]    5    2
# [3,]    4    1
m1 %..% m2
#      [,1] [,2]
# [1,]    7    4
# [2,]    8    5



##### algstat
########################################

data(politics)
politics
#            Party
# Personality Democrat Republican
#   Introvert        3          7
#   Extrovert        6          4

(A <- hmat(c(2, 2), list(1, 2))) # alternative to genmodel
#    11 12 21 22
# 1+  1  1  0  0
# 2+  0  0  1  1
# +1  1  0  1  0
# +2  0  1  0  1
countTables(politics, A)
# [1] 10

loglinear(~ Personality + Party, data = politics)
# Computing Markov moves (4ti2)... done.
# Running chain (C++)... done.
# Call:
# loglinear(model = ~Personality + Party, data = politics)
# 
# Fitting method:
# Iterative proportional fitting (with stats::loglin)
# 
# MCMC details:
# N = 10000 samples (after thinning), burn in = 1000, thinning = 10
# 
#       Distance   Stat     SE p.value     SE mid.p.value
#        P(samp)                0.3677 0.0048      0.2201
#    Pearson X^2 1.8182 0.0146  0.3677 0.0048      0.2201
# Likelihood G^2 1.848  0.0155  0.3677 0.0048      0.2201
#  Freeman-Tukey 1.8749 0.0167  0.3677 0.0048      0.2201
#   Cressie-Read 1.8247 0.0148  0.3677 0.0048      0.2201
#     Neyman X^2 2.0089 0.0223  0.3677 0.0048      0.2934





