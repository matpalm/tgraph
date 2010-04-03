processing clique #<struct Graph v=[5, 6], gid=4, pgid=2, row=nil, height=1>
r_matrix =  [[-5, -6]]
r_heights = [1]
clique #<struct Graph v=[5, 6], gid=4, pgid=2, row=1, height=1>
processing clique #<struct Graph v=[1, 2, 4], gid=6, pgid=5, row=nil, height=1>
r_matrix =  [[-5, -6], [-1, -2], [2, -4]]
r_heights = [1, 1, 1]
clique #<struct Graph v=[1, 2, 4], gid=6, pgid=5, row=3, height=1>
processing other row nil
r_matrix =  [[-5, -6], [-1, -2], [2, -4], [3, -3]]
r_heights = [1, 1, 1, 3]
graph #<struct Graph v=[1, 2, 3, 4], gid=5, pgid=2, row=4, height=3>
processing other row nil
r_matrix =  [[-5, -6], [-1, -2], [2, -4], [3, -3], [1, 4]]
r_heights = [1, 1, 1, 3, 7]
graph #<struct Graph v=[1, 2, 3, 4, 5, 6], gid=2, pgid=1, row=5, height=7>
processing other row nil
r_matrix =  [[-5, -6], [-1, -2], [2, -4], [3, -3], [1, 4], [-7, 5]]
r_heights = [1, 1, 1, 3, 7, 8]
graph #<struct Graph v=[1, 2, 3, 4, 5, 6, 7], gid=1, pgid=nil, row=6, height=8>
a <- list()
a$merge <- matrix(c(-5,-6,-1,-2,2,-4,3,-3,1,4,-7,5), nc=2, byrow=TRUE)
a$height <- c(1,1,1,3,7,8)
a$order <- 1:7
a$labels <- c("gutta","mat_kelcey","markmansour","robertpostill","hiremaga","markryall","JimSlaton")
class(a) <- "hclust"
jpeg("dendrogram.jpg", width=400, height=400)
plot(as.dendrogram(a))
dev.off()
