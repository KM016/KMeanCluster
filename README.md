# KMeanCluster

05/2024  
University Project

# The Task

This project focuses on implementing a **clustering algorithm** to group similar data points together. The project is based on the well-known **Iris dataset**, which consists of measurements for 150 iris flowers. Each flower is represented by four attributes: **Sepal Length**, **Sepal Width**, **Petal Length**, and **Petal Width**.

The goal is to group the flowers into clusters based on these attributes using a **K-means-like clustering algorithm**. Clustering is performed using a distance metric (L1 distance, also known as Taxicab distance) to determine the similarity between observations. 

## Clustering Algorithm

### Overview

The clustering algorithm follows an iterative approach similar to **K-means clustering**, where:
1. Initial cluster centers are selected randomly.
2. Each data point is assigned to the cluster center that it is closest to (using L1 distance).
3. Cluster centers are updated based on the assignments of data points.
4. This process is repeated until no further cost reduction (total distance) is possible or a maximum number of iterations is reached.

## Steps Involved

1. **Distance Calculation**:  
   The L1 distance between two points $x$ and $y$ in a d-dimensional space is calculated as:
   $\text{dist}(x, y) = \sum_{i=1}^d |x_i - y_i|$

2. **Cluster Assignment**:  
   Each observation (data point) is assigned to the nearest cluster center based on the L1 distance.

3. **Cluster Center Update**:  
   The cluster centers are updated based on the new assignments, and the total cost (sum of distances) is computed.

4. **Iterations**:  
   The process repeats, adjusting cluster centers and assignments until no cost reduction is possible or the maximum number of iterations is reached.

# The Code

The project is implemented in **R**, and the following functions were developed:

- `dist_vect(x, y)`: Computes the L1 distance between two vectors.
- `dist_mat(X, y)`: Computes the distances between a vector `y` and all rows of a matrix `X`.
- `dist_mat_fast(X, y)`: A vectorized version of `dist_mat` for efficiency.
- `find_nearest(X, C)`: Assigns data points to the nearest cluster centers.
- `dist_tot(X, C, cl)`: Computes the total cost (sum of distances) of the current clustering.
- `plot_clustering(X, C, cl)`: Visualizes the clusters with data points and cluster centers.

Additionally, the clustering algorithm is implemented in the `clu_algo` function, which runs the full clustering procedure, adjusting centers and assignments, and outputs the final cluster assignments and total cost.


**Mark:** For this project I achieved an 88/100

# Revisiting
08/2024 <br>
- revisted this code and implemented the algorithm in python
