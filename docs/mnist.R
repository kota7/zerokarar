## load mnist data



load_mnist <- function(normalize=TRUE, flatten=TRUE, one_hot_label=FALSE)
{
  url_base = 'http://yann.lecun.com/exdb/mnist/'
  files <- c(train_img   = 'train-images-idx3-ubyte.gz',
             train_label = 'train-labels-idx1-ubyte.gz',
             test_img    = 't10k-images-idx3-ubyte.gz',
             test_label  = 't10k-labels-idx1-ubyte.gz')
  rawdir <- 'mnist-raw/'
  rdsfile <- 'dataset/mnist.rds'

  download_mnist <- function()
  {
    # download original data
    if (!dir.exists(rawdir)) dir.create(rawdir)
    for (fn in files)
    {
      destfile <- file.path(rawdir, fn)
      if (file.exists(destfile)) {
        message(destfile, " already exists")
        next
      }
      cat(url, "\n->", destfile, "...\n")
      url <- paste(url_base, fn, sep="")
      download.file(url, destfile=destfile, mode='wb', method="libcurl")
    }
  }


  prep_label <- function(fn)
  {
    # parse label data into R object
    con <- gzfile(fn, "rb")
    header <- readBin(con, integer(), size=4, n=2, endian="big")
    # header is written in 32bit (=4 bytes) integer
    # magick, N
    y <- readBin(con, integer(), size=1, n=header[2], endian="big")
    # data are 1 byte integer
    close(con)
    y
  }

  prep_image <- function(fn)
  {
    # parse image data into R object
    con <- gzfile(fn, "rb")
    header <- readBin(con, integer(), size=4, n=4, endian="big")
    # header is written in 32bit (=4 bite) integer
    # magick, N, nrow, ncol
    x <- readBin(con, integer(), size=1, n=prod(header[2:4]),
                 endian="big", signed=FALSE)
    # data are 1 byte integer
    close(con)

    x <- array(x, dim=c(prod(header[3:4]), header[2]))
    t(x)
  }


  init_mnist <- function()
  {
    download_mnist()
    out <- list()

    for (key in names(files))
    {
      fn <- file.path(rawdir, files[key])
      cat("preparing", key, "...\n")

      if (grepl("_img", key)) {
        out[[key]] <- prep_image(fn)
      } else {
        out[[key]] <- prep_label(fn)
      }
    }
    saveRDS(out, rdsfile)
  }

  if (!file.exists(rdsfile)) init_mnist()

  out <- readRDS(rdsfile)

  if (normalize) {
    out$train_img <- out$train_img/255
    out$test_img <- out$test_img/255
  }

  if (!flatten) {
    # convert to (N,nrow,ncol) array
    expand <- function(a)
    {
      dim(a) <- c(dim(a)[1], sqrt(dim(a)[2]), sqrt(dim(a)[2]))
      # need to swap the dimensions because data comes as row-first order
      # while R's default is column-first order
      a <- aperm(a, c(1,3,2))
    }
    out$train_img <- expand(out$train_img)
    out$test_img <- expand(out$test_img)
  }

  if (one_hot_label) {
    out$train_label <- nnet::class.ind(out$train_label)
    out$test_label <- nnet::class.ind(out$test_label)
  }

  out
}

