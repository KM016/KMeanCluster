
##Part 1

# dis vect function
dist_vect <- function(x, y) {
  if (length(x) != length(y)) {
    stop("Dimension Error - dist_vect")
  } else {
    return(sum(abs(x - y)))
  }
}


# dis mat function
dist_mat <- function(X, y) {
  dist <- numeric(NROW(X))
  for (i in 1:NROW(X)) {
    dist[i] <- dist_vect(X[i, ], y)
  }
  return(dist)
}

# faster version with no loops 
dist_mat_fast <- function(X, y) {
  return(colSums(abs(t(X) - y[1:length(y)])))
}

# test case 
set.seed(414)
X <- matrix(rnorm(30), nrow = 10, ncol = 3)
y <- rnorm(3)

dist_mat(X, y)
dist_mat_fast(X, y)



# creating simulated data
set.seed(4184)
n <- 200
X <- matrix(rnorm(n * 2, sample(c(-2, 2), n * 2, replace = TRUE), 1), n, 2)


# initialising location of clusters 
k <- 4
id_C <- 1:k
C <- X[id_C, ]




##Part 2

# finding nearest function 
find_nearest <- function(X, C) {
  cl <- vector('list', nrow(C))
  for (i in 1:nrow(X)) {
    distances <- lapply(1:nrow(C), function(j) dist_vect(X[i, ], C[j, ]))
    closest_center <- which.min(distances)
    cl[[closest_center]] <- c(cl[[closest_center]], i)
  }
  return(cl)
}

# dist tot function 
dist_tot <- function(X, C, cl) {
  total_distance <- 0
  for (j in 1:length(cl)) {
    for (i in cl[[j]]) {
      total_distance <- total_distance + dist_vect(X[i, ], C[j, ])
    }
  }
  return(total_distance)
}

# plotting function for clusters 
plot_clustering <- function(X, C, cl, main_title , xlab, ylab) {
  plot(X[, 1], X[, 2], col = 'black', pch = 20, cex = 0.5, xlab = xlab, ylab = ylab, main = main_title)
  colors <- c('navy', 'red2', 'orange', 'purple')[1:max(unlist(cl))]
  for (i in seq_along(cl)) {
    if (length(cl[[i]]) > 0) {
      points(X[cl[[i]], 1], X[cl[[i]], 2], col = colors[i], pch = 16, cex = 1)
      if (!is.null(C) && nrow(C) >= i) {
        points(C[i, 1], C[i, 2], col = colors[i], pch = 8, cex = 4)
      }
    }
  }
}

# running find nearest
cl <- find_nearest(X, C)
dist_tot(X, C, cl)

#plotting results 
png("points.png", width = 500, height = 500)
plot_clustering(X, C, cl, "Points", "X1", "X2")
dev.off()



##Part 3

# clu algo function 
clu_algo <- function(X, k, max_iter) {
  C <- X[sample(nrow(X), k), ]
  best_cost <- Inf
  best_C <- C
  best_cl <- list()
  #runs find nearest 
  for (n in 1:max_iter) {
    cl <- find_nearest(X, C)
    current_cost <- dist_tot(X, C, cl)
    cheaper <- FALSE
    #checks to see if there is a cheaper cost 
    for (j in 1:k) {
      for (i in 1:nrow(X)) {
        temp_C <- C
        temp_C[j, ] <- X[i, ]
        temp_cl <- find_nearest(X, temp_C)
        temp_cost <- dist_tot(X, temp_C, temp_cl)
        if (temp_cost < best_cost) {
          best_cost <- temp_cost
          best_C <- temp_C
          best_cl <- temp_cl
          cheaper <- TRUE
        }
      }
    }
    #if cheaper cost found assigns best_c to C
    if (cheaper) {
      C <- best_C
    } 
    #else breaks loop
    else {
      break
    }
  }
  return(list(C = best_C, cl = best_cl, cost = best_cost))
}


# testing and plotting clu algo 
result <- clu_algo(X, 4, 50)
paste("Cost at convergence:", result$cost)
png("clust.png", width = 500, height = 500)
plot_clustering(X, result$C, result$cl, "Clust", "X1", "X2")
dev.off()



##Part 4
# applying clu algo to iris
data("iris")
#breaks iris into only the first 4 cols and creates pairings out of them 
iris_data <- iris[, 1:4]
pairs <- combn(1:ncol(iris_data), 2)
datasets <- lapply(1:ncol(pairs), function(i) iris_data[, pairs[, i]])
#applys clu alg on each pairing
clustering_results <- lapply(datasets, function(dataset) {
  clu_algo(as.matrix(dataset), k = 2, max_iter = 50)
})



# plotting irist clusterings

## Note:
# 1 = sepal length
# 2 = sepal width
# 3 = petal length
# 4 = petal width

png("iris.png", width = 1000, height = 800)
par(mfrow = c(2, 3))
for (i in seq_along(clustering_results)) {
  result <- clustering_results[[i]]
  plot_clustering(as.matrix(datasets[[i]]), result$C, result$cl, paste(colnames(iris[pairs[1, i]]), "vs", colnames(iris[pairs[2, i]])), paste(colnames(iris[pairs[1, i]])) , paste(colnames(iris[pairs[2, i]])))
}
dev.off()

# paste(colnames(iris[pairs[1,1]]))