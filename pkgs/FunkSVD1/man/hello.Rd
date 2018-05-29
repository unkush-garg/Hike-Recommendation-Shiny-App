\name{r.svdf}
\alias{hello}
\title{Funk SVD for Hike Recommendation}
\usage{
Recommender(getData(file, data), method = "SVDF")
}
\description{
Implements matrix decomposition by the stochastic gradient descent optimization to minimize error on known values
}
\examples{
r.svdf <- Recommender(getData(div, "train"), "SVDF")
}
