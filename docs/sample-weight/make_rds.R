b1 <- scan("sample-weight/b1")
b2 <- scan("sample-weight/b2")
b3 <- scan("sample-weight/b3")

W1 <- read.table("sample-weight/W1", header=FALSE, sep=" ")
W2 <- read.table("sample-weight/W2", header=FALSE, sep=" ")
W3 <- read.table("sample-weight/W3", header=FALSE, sep=" ")
W1 <- as.matrix(W1)
W2 <- as.matrix(W2)
W3 <- as.matrix(W3)
dimnames(W1) <- NULL
dimnames(W2) <- NULL
dimnames(W3) <- NULL


out <- list(b1=b1, b2=b2, b3=b3, W1=W1, W2=W2, W3=W3)
saveRDS(out, "sample_weight.rds")
