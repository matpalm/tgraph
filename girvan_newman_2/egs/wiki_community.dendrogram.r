a <- list()
a$merge <- matrix(c(-1,-2,1,-4,-5,-6,3,-8,-12,-13,5,-14,-11,6,4,-9,-10,7,-7,8,-3,9,10,11,2,12), nc=2, byrow=TRUE)
a$height <- c(1,1,1,1,1,1,3,8,10,11,11,14,16)
a$order <- 1:14
a$labels <- 1:14
class(a) <- "hclust"
jpeg("wiki_dendro.jpg", width=400, height=400)
plot(as.dendrogram(a))
dev.off()
