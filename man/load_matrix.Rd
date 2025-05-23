% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stages.R
\name{load_matrix}
\alias{load_matrix}
\title{Load a matrix for later use}
\usage{
load_matrix(matrix, check = TRUE)
}
\arguments{
\item{matrix}{a 4x4 matrix typically a Rotation-Translation Matrix (RTM)}

\item{check}{Boolean. Check matrix orthogonality.}
}
\description{
Load a matrix for later use. For example, load a matrix to feed the \link{transform_with}
stage
}
\examples{
a = 20 * pi / 180
m <- matrix(c(
  cos(a), -sin(a), 0, 1000,
  sin(a), cos(a), 0, 0,
  0, 0, 1, 0,
  0, 0, 0, 1), nrow = 4, byrow = TRUE)

mat = load_matrix(m)
trans = transform_with(mat)
write = write_las(tempfile(fileext = ".las"))
pipeline = mat + trans + write

f <- system.file("extdata", "Topography.las", package="lasR")

exec(pipeline, on = f)
}
