
#DoSNOW to run multiple cores 
system.time(Recommender(getData(div, "train"), "SVDF"))
install.packages("doSNOW")
library(doSNOW)
cl <- makeCluster(6,type = "SOCK")
registerDoSNOW(cl)

#install packages
install.packages("DataCombine")
install.packages("recommenderlab")
install.packages("recosystem")
install_github(repo = "SlopeOne", username = "tarashnot")
install_github(repo = "SVDApproximation", username = "tarashnot")

#import libraries 
library(devtools)
library(recommenderlab)
library(recosystem)
library(SlopeOne)
library(SVDApproximation)
library(DataCombine)
library(data.table)
library(RColorBrewer)
library(ggplot2)
library(dplyr)

#work with a subset of data --> user_id, hike_id and ratings 
#drop NAs
#convert all objects to characters
ratings <- out[,c(84,85,83)]
ratings <- DropNA(ratings)
ratings<- mutate_all(ratings, function(x) as.numeric(as.character(x)))
summary(ratings)

#convert df to sparse matrix
sparse_ratings <- sparseMatrix(i = ratings$user_id, j = ratings$hike_id, x = ratings$rating_y)
sparse_ratings[10:20, 10:30]

#for recommender lab, convert sparse_ratings to a "realRatingMatrix"
real_ratings <- new("realRatingMatrix", data = sparse_ratings)
class(small_real_ratings)

#model <- Recommender(real_ratings, method = "UBCF")
#any(grepl("RStudio", .libPaths()))

#recosystem Matrix Factorization
set.seed(1)
in_train <- rep(TRUE, nrow(ratings))
in_train[sample(1:nrow(ratings), size = round(0.2 * length(unique(ratings$user_id)), 0) * 5)] <- FALSE
ratings_train <- ratings[(in_train),]
write.table(ratings_train, file = "trainset.txt", sep = " ", row.names = FALSE, col.names = FALSE)
write.table(ratings_test, file = "testset.txt", sep = " ", row.names = FALSE, col.names = FALSE)

#initiate recosystem 
r = Reco()

#don't run because this takes a while
opts <- r$tune("trainset.txt", opts = list(dim = c(1:20), lrate = c(0.05),nthread = 4, costp_l1 = c(0,0.1), niter = 200, nfold = 10, verbose = FALSE))
r$train("trainset.txt", opts = c(opts$min, nthread = 4, niter = 500, verbose = FALSE))
outfile = tempfile()
r$predict("testset.txt", outfile)

#evaluate recosystem 
scores_real <- read.table("testset.txt", header = FALSE, sep = " ")$V3
scores_pred <- scan(outfile)
rmse_mf <- sqrt(mean((scores_real-scores_pred) ^ 2))
rmse_mf

set.seed(1)
mtx <- split_ratings(ratings_train, proportion = c(0.7, 0.15, 0.15))

train<- read.delim2('trainset.txt',sep = " ",header = FALSE)
test <- read.delim2('testset.txt',sep = " ",header = FALSE)
fsvd <- funkSVD(df.wide,k=40,verbose = TRUE)

r <- tcrossprod(fsvd$U, fsvd$V)
RMSE(train, r)

testing <- predict(fsvd, test, verbose = TRUE)
RMSE(test, testing)

#convert users vs. hikes in a large matrix form 
df.wide.T.users <- dcast(ratings, user_id ~ hike_id,value.var='rating_y', mean, fill=0)

#let's start with SVD and Funk 

#What's available in recommenderlab package
recommenderRegistry$get_entries()

ml <- real_ratings
#normalize data
ml_n <- normalize(ml)

#check rowcounts and class to make sure everything is prepped for the alg
min(rowCounts(real_ratings))
class(ml)

#split data 90/10 split
div <- evaluationScheme(ml_n, method="split", train = 0.9, given =1, goodRating = 5)
div

#train r.svd on train method using Recommender package
r.svd <- Recommender(getData(div, "train"), "SVD")

#save r.svd down for later use
save(r.svd, file = "my_modelSVD.rda")

#train r.svdf on training set using Recommender package
r.svdf <- Recommender(getData(div, "train"), "SVDF")

#save r.svdf down for later use
save(r.svdf, file = "my_modelSVDF.rda")

#check if save was successful 
load('my_modelSVD.rda')
r.svd
load('my_modelSVDF.rda')
r.svdf

#let's predict some ratings and evaluate using Recommender lab 
p.svd <- predict(r.svd, getData(div, "known"), type = "ratings")
p.svdf <- predict(r.svdf, getData(div, "known"), type = "ratings")

#take a look at what the prediction matrices look like
getRatingMatrix(p.svd)[1:6,1:6]
getRatingMatrix(p.svdf)[1:6,1:6]

#Evaluate using Recommender lab
SVD <- calcPredictionAccuracy(p.svd, getData(div, "unknown"))
SVD

#Evaluate using Recommender lab
SVDF <- calcPredictionAccuracy(p.svdf, getData(div, "unknown"))
SVDF

## code for UBCF, IBCF will go here. Hypothetically speaking, scores for UBCF and IBCF should be higher than what is seen with SVD/SVDF
