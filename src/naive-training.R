source("mnist.R")
library(nnet)
d <- load_mnist(normalize=TRUE, flatten=TRUE, one_hot_label=FALSE)

# Simplify the problem to classification of 1, 2, and 3
# because this naive implementation is slow
ss <- d$train_label %in% c(1, 2, 3)
d$train_img <- d$train_img[ss, , drop=FALSE]
d$train_label <- d$train_label[ss]

ss <- d$test_label %in% c(1, 2, 3)
d$test_img <- d$test_img[ss, , drop=FALSE]
d$test_label <- d$test_label[ss]

# to one-hot format
d$train_label <- class.ind(d$train_label)
d$test_label <- class.ind(d$test_label)


iter_nums <- 1000
train_size <- dim(d$train_img)[1]
batch_size <- 100
learning_rate <- 0.1

network <- TwoLayerNet$new(input_size=dim(d$train_img)[2], output_size=3, hidden_size=3)

train_loss <- numeric(0)
train_acc <- numeric(0)
test_acc <- numeric(0)
for (i in 1:iter_nums)
{
  cat(sprintf("\r%4d/%4d", i, iter_nums))
  batch_index <- sample(train_size, batch_size)
  x <- d$train_img[batch_index,,drop=FALSE]
  y <- d$train_label[batch_index,,drop=FALSE]

  grad <- network$numerical_gradient(x, y)
  for (name in names(network$params))
  {
    network$params[[name]] <- network$params[[name]] - learning_rate*grad[[name]]
  }

  loss <- network$loss(x, y)
  train_loss <- c(train_loss, loss)

  if (i %% 50 == 1) {
    train_acc <- c(train_acc, network$accuracy(d$train_img, d$train_label))
    test_acc  <- c(test_acc, network$accuracy(d$test_img, d$test_label))
    cat("\n * test and train accuracy =", tail(test_acc,1), tail(test_acc,1), "\n")
  }
}

naive_training <- list(train_loss=train_loss, train_acc=train_acc, test_acc=test_acc)
saveRDS(naive_training, "naive-train-result.rds")
