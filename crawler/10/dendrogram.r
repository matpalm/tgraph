a <- list()
a$merge <- matrix(c(-3,-4,1,-6,2,-2,-5,3,-1,4,-7,5), nc=2, byrow=TRUE)
a$height <- c(1,1,3,5,8,9)
a$order <- 1:7
a$labels <- c("markmansour","hiremaga","mat_kelcey","markryall","gutta","robertpostill","JimSlaton")
class(a) <- "hclust"
jpeg("dendrogram.jpg", width=400, height=400)
plot(as.dendrogram(a))
dev.off()
