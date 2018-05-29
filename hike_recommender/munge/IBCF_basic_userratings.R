library(reshape2)
library(plyr)

head(rating_popular_hike)

n <- 29
hike_counts <- table(rating_popular_hike$hike_name)
hikes <- names(hike_counts[hike_counts > n])
head(hikes)
head(hike_counts)
df <- rating_popular_hike[rating_popular_hike$hike_name %in% hikes,]

df.wide <- dcast(df, hike_name ~ user_id,
                 value.var='rating_y', mean, fill=0)
head(df.wide)

dists <- dist(df.wide[,-1], method="cosine")
dists <- as.data.frame(as.matrix(dists))
colnames(dists) <- df.wide$hike_name
dists$hike_name <- df.wide$hike_name
head(dists)


getSimilarhikes <- function(hikes_i_like) {
  hikes_i_like <- as.character(hikes_i_like)
  cols <- c("hike_name", hikes_i_like)
  best.hikes <- dists[,cols]
  if (ncol(best.hikes) > 2) {
    best.hikes <- data.frame(hike_name=best.hikes$hike_name, V1=rowSums(best.hikes[,-1]))
  }
  results <- best.hikes[order(best.hikes[,-1]),]
  names(results) <- c("hike_name", "similarity")
  results[! results$hike_name %in% hikes_i_like,]
}

getSimilarhikes(c("17-Mile Drive to Carmel Road Ride","Los Santos-Trans Preserve Loop"))

model.transform <- function(df) {
  df
}

model.predict <- function(df) {
  getSimilarhikes(df$hikes)
}

testcase <- data.frame(hikes=c("Lake Merritt","Los Santos-Trans Preserve Loop"))
testcase.predictions <- model.predict(testcase)

print(testcase.predictions[0:5,1])

