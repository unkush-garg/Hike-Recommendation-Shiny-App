\name{r.svd}
\alias{hello}
\title{SVD for Hike Recommendation}
\usage{
Recommender(getData(file, data), method = "SVD")
}
\description{
Implements matrix decomposition by mean optimization to minimize error on known values
}
\examples{
r.svd <- Recommender(getData(div, "train"), "SVD")
}
