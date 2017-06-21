sigmoid <- function(a)
{
  # a: numeric array
  #
  # returns: array of the same wize as a
  1 / (1 + exp(-a))
}


relu <- function(a)
{
  # a: numeric array
  #
  # returns: array of the same wize as a
  pmax(0, a)
}


softmax <- function(a)
{
  # a : either numeric vector or matrix of size (N, classes)
  #
  # returns: probability matrix of size (N, classes)

  if (is.vector(a)) dim(a) <- c(1, length(a))

  C <- max(a)
  exp_a <- exp(a-C)
  exp_a / rowSums(exp_a)
}



cross_entropy_error <- function(p, y)
{
  # p: predicted probability
  # y: true label, one hot form
  if (is.vector(p)) dim(p) <- c(1, length(p))
  if (is.vector(y)) dim(y) <- c(1, length(y))
  -sum(y * log(p + 1e-7)) / nrow(p)
}

