a <- list()
a$merge <- matrix(c(-1, -2,
                    1,  -5,
                    -4, -6,
                    -7, -8,
		    4, -10,
		    5, -11,
                    2, -3,
		    3, 7,
		    6, -12,
		    9, -9,
		    8, 10), nc=2, byrow=TRUE )
a$height <- c(1, 1, 1, 1, 1, 2, 4, 5, 7, 10, 11)
a$order <- 1:12
a$labels <- 1:12 # LETTERS[1:6]
class(a) <- "hclust"
plot(as.dendrogram(a))
