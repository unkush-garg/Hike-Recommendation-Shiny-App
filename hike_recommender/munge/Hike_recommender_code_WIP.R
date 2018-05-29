getwd()
setwd("/Users/ankushgarg/project/hike_recommender/munge/")
install.packages('recommenderlab')
install.packages('data.table')
install.packages('dplyr')
install.packages('tidyr')
install.packages('ggplot2')
install.packages('stringr')
install.packages('DT')
install.packages('knitr')
install.packages('grid')
install.packages('gridExtra')
install.packages('corrplot')
install.packages('qgraph')
install.packages('methods')
install.packages('Matrix')
install.packages('reticulate')
install.packages('magrittr')
library(reticulate)
library(recommenderlab)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(DT)
library(knitr)
library(grid)
library(gridExtra)
library(corrplot)
library(qgraph)
library(methods)
library(Matrix)
library(magrittr)

## Read in files and take a look
summary(ratings)

#drop duplicates from ratings dataset

dups <- hikes[c("hike_id","user_id")]
ratings <- hikes[!duplicated(dups),]
ratings <- ratings[,84:86]

## Distribution of ratings by users
ratings %>%
  ggplot(aes(x = rating_y, fill = factor(rating_y))) +
  geom_bar(color = "grey20") + scale_fill_brewer(palette = "YlGnBu") + guides(fill = FALSE)

## Distribution of mean user ratings
ratings %>%
  group_by(user_id) %>%
  summarize(number_of_ratings_per_user = n()) %>%
  ggplot(aes(number_of_ratings_per_user)) +
  geom_bar(fill = "cadetblue3", color = "grey20") + coord_cartesian(c(3, 50))

## Number of ratings per hike
ratings %>%
  group_by(hike_id) %>%
  summarize(number_of_ratings_per_hike = n()) %>%
  ggplot(aes(number_of_ratings_per_hike)) +
  geom_bar(fill = "cadetblue3" , color = "grey20",width = 1) + coord_cartesian(c(0,40))
## Looks like close to 750 hikes have 30 or more ratings. And close to 2000 hikes have 1 or 2 ratings per

ratings %>%
  group_by(hike_id) %>%
  summarize(mean_hike_rating = mean(rating_y)) %>%
  ggplot(aes(mean_hike_rating)) + geom_histogram(fill = "cadetblue3", color = "grey20") + coord_cartesian(c(1,5))


ratings %>%
  group_by(hike_id) %>%
  summarize(number_of_ratings_per_hike = n()) %>%
  ggplot(aes(number_of_ratings_per_hike)) +
  geom_bar(fill = "cadetblue3", color = "grey20", width = 1) + coord_cartesian(c(0,40))

dimension_names <- list(user_id = sort(unique(ratings$user_id)), hike_id = sort(unique(ratings$hike_id)))
ratingmat <- spread(select(ratings, hike_id, user_id, rating_y), hike_id, rating_y) %>% select(-user_id)

ratingmat <- as.matrix(ratingmat)
dimnames(ratingmat) <- dimension_names
ratingmat[1:5, 1:5]

dim(ratingmat)
current_user = '4670'
ratingmat0 <- ratingmat
ratingmat0[is.na(ratingmat0)] <- 0
sparse_ratings <- as(ratingmat0, "sparseMatrix")
rm(ratingmat0)
gc()

real_ratings <- new("realRatingMatrix", data = sparse_ratings)
real_ratings

model <- Recommender(real_ratings, method = "UBCF", param = list(method = "pearson", nn = 4))

prediction <- predict(model, real_ratings[current_user, ], type = "ratings")

scheme <- evaluationScheme(real_ratings[,], method = "cross-validation", train = 0.8, k = 5, given = -1,goodRating = 5 )

dim(real_ratings)

recommenderRegistry$get_entries(dataType = "realRatingMatrix")

ratingmat <- sparseMatrix(i = ratings$hike_id,ratings$user_id, x = ratings$rating_y,index1 = FALSE) # hike x user matrix
ratingmat <- ratingmat[,unique(summary(ratingmat)$j)] # remove unselected users
dimnames(ratingmat) <- list(book_id = as.character(1:10000),
                            user_id = as.character(sort(unique(ratings$user_id))))

N= sparseMatrix(i=x[,1], j=x[,2], x=x[,3])



