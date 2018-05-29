install.packages('Recommenderlab')
library(recommenderlab)
r.svd <- Recommender(getData(div, "train"), "SVD")
