# L1 Clustering from Scratch in R

A from-scratch implementation of an L1-distance clustering algorithm, tested on simulated data and applied to pairwise views of the Iris dataset.

> University of Bristol Coursework<br>
> **Mark awarded:** 88/100<br>
> Date: 05/2024

## Project overview

The coursework asked for a complete clustering procedure to be built in R without using an existing clustering implementation. The work begins with general distance functions, develops cluster-assignment and cost calculations, and combines them into an iterative optimisation algorithm. The completed method is then applied to both a synthetic dataset and the Iris dataset.

The method is described in the assignment as K-means-like because observations are repeatedly assigned to their nearest cluster centre. However, it differs from standard k-means in two important ways:

- similarity is measured using **L1 distance** rather than squared Euclidean distance; and
- each centre must be one of the observed data points rather than the arithmetic mean of a cluster.

It is therefore more accurately understood as a medoid-style local-search algorithm.

## Coursework structure

The assignment was divided into four parts:

1. **Distance functions:** implement loop-based and vectorised L1-distance calculations.
2. **Cluster assignment:** assign observations to their nearest centres, calculate total cost and visualise the result.
3. **Clustering algorithm:** search for centre replacements that reduce total within-cluster distance.
4. **Iris analysis:** apply the algorithm to all six pairs of the four numerical Iris features.

The submitted solution is contained in `cluster_vis.R` and follows this structure directly.

## Distance and objective function

For two observations $x,y\in\mathbb{R}^d$, the L1 or Taxicab distance is

$$
d(x,y)=\sum_{i=1}^{d}|x_i-y_i|.
$$

If $C_j$ is the centre of cluster $j$ and $cl_j$ contains the indices assigned to it, the clustering cost is

$$
\operatorname{cost}(X,C,cl)
=\sum_{j=1}^{k}\sum_{i\in cl_j} d(X_i,C_j).
$$

The optimisation aims to reduce this total distance.

## Clustering algorithm

Given an $n\times d$ data matrix $X$, a cluster count $k$ and an iteration limit:

1. randomly select $k$ observations from $X$ as the initial centres;
2. assign every observation to its nearest centre using L1 distance;
3. calculate the total clustering cost;
4. consider replacing each centre with every observation in the dataset;
5. recalculate the assignments and cost for every proposed replacement;
6. retain the replacement producing the lowest cost;
7. update the centres and repeat; and
8. stop when no cheaper replacement is found or `max_iter` is reached.

Restricting centres to observed rows of $X$ makes each selected centre directly interpretable as a representative observation.

## Functions implemented

| Function | Purpose |
| --- | --- |
| `dist_vect(x, y)` | Calculates the L1 distance between two equal-length vectors. |
| `dist_mat(X, y)` | Calculates the distance from `y` to every row of `X` using a loop. |
| `dist_mat_fast(X, y)` | Repeats the matrix-distance calculation using vectorised R operations. |
| `find_nearest(X, C)` | Assigns each observation to its closest cluster centre. |
| `dist_tot(X, C, cl)` | Calculates total distance from observations to their assigned centres. |
| `plot_clustering(X, C, cl, ...)` | Plots observations by cluster and marks their centres. |
| `clu_algo(X, k, max_iter)` | Runs the complete centre-swap clustering algorithm. |

The solution uses base R throughout. Vectorisation is used for `dist_mat_fast`, while `lapply` is used when evaluating distances to multiple centres and when applying the algorithm across the Iris feature pairs.

## Experiments

### Distance-function check

A reproducible `10 x 3` random matrix and three-dimensional vector are generated with `set.seed(414)`. The loop-based and vectorised matrix-distance functions return the same values, checking that the vectorised implementation preserves the original calculation.

### Simulated four-cluster data

The main synthetic experiment uses `set.seed(4184)` to generate 200 two-dimensional observations around combinations of `-2` and `2`.

The first four observations are initially used as centres to demonstrate cluster assignment, cost calculation and plotting. The full algorithm is then run with:

- `k = 4` clusters; and
- `max_iter = 50`.

In the preserved run, the initial configuration has total cost `413.6783`, while the centre-swap algorithm converges to a cost of approximately `268.5536`.

### Iris dataset

The Iris dataset contains 150 flowers and four numerical measurements:

- sepal length;
- sepal width;
- petal length; and
- petal width.

All six two-feature combinations are created using `combn`. The clustering algorithm is applied to each projection with `k = 2`, as required by the specification. The known species labels are not used during clustering, so this remains an unsupervised analysis.

## Visual outputs

Running the R script generates:

- `points.png` - assignments produced by the first four synthetic observations used as centres;
- `clust.png` - the final four-cluster solution on the simulated data; and
- `iris.png` - a `2 x 3` panel showing the six pairwise Iris clustering results.

Cluster membership is shown by colour and the selected centres are marked with star-shaped points.

## Repository contents

```text
.
├── cluster_vis.R    # Original submitted R coursework
└── README.md        # Project documentation
```

## Scope and limitations

The algorithm uses a single random initialisation and does not compare multiple restarts. Its exhaustive centre-swap search is also computationally expensive because every observation is tested as a replacement for every centre. The Iris analysis considers two features at a time rather than fitting one model to all four measurements, and it visualises the assignments without calculating an external clustering score against the species labels.

This repository intentionally preserves the original R submission. No later Python port or code refactor is included.
