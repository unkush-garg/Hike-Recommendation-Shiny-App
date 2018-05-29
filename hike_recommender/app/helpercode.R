#read csv with similarity matrix based off euclidean distances from ratings and geocodes
dists <- read.csv('dists_euclidean.csv',check.names = FALSE,stringsAsFactors = FALSE)

#original trails with attributes for output
trail.attributes <- read.csv('trailattributes.csv', check.names = FALSE, stringsAsFactors = FALSE)

#function to search for similar trails based off similarities
getSimilarhikes <- function(hikes_i_like) {
  hikes_i_like <- as.character(hikes_i_like)
  cols <- c("hike_name", hikes_i_like)
  best.hikes <- dists[,cols]
  if (ncol(best.hikes) > 2) {
    best.hikes <- data.frame(hike_name=best.hikes$hike_name, V1=rowSums(best.hikes[,-1]))
  }
  results <- best.hikes[order(best.hikes[,-1]),]
  names(results) <- c("hike_name", "similarity")
  results <-results[! results$hike_name %in% hikes_i_like,]}
  
