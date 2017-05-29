image_plot <- function(arr)
{
  out <- grid::rasterGrob(arr)

  out <- ggplot2::qplot(0.5, 0.5, xlim=c(0,1), ylim=c(0,1)) +
    ggplot2::theme_void() + ggplot2::xlab('') + ggplot2::ylab('') +
    ggplot2::annotation_custom(out)

  out
}

random_plot <- function(x, y)
{
  index <- sample(length(y), min(16, length(y)))
  graph_list <- lapply(index, function(i) {
    image_plot(x[i,,]) + ggplot2::ggtitle(y[i])
  })
  gridExtra::grid.arrange(grobs=graph_list, nrow=4, ncol=4)
}
