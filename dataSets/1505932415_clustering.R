# Section 7.3 Exercise
# Pasco Gasbarro
# 3/15/2019


# This mini-project is based on the K-Means exercise from 'R in Action'
# Go here for the original blog post and solutions
# http://www.r-bloggers.com/k-means-clustering-from-r-in-action/

# Exercise 0: Install these packages if you don't have them already
install.packages(c("cluster", "rattle.data","NbClust"))

# Now load the data and look at the first few rows
data(wine, package="rattle.data")
head(wine)

# Exercise 1: Remove the first column from the data and scale
# it using the scale() function
wineRevised <- scale(wine[-1]) 
head(wineRevised)
wineRevised <- scale(wineRevised)
head(wineRevised)

# Now we'd like to cluster the data using K-Means. 
# How do we decide how many clusters to use if you don't know that already?
# We'll try two methods.
# Method 1: A plot of the total within-groups sums of squares against the 
# number of clusters in a K-means solution can be helpful. A bend in the 
# graph can suggest the appropriate number of clusters. 

wssplot <- function(data, nc=15, seed=1234) {
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
	  set.seed(seed)
	  wss[i] <- sum(kmeans(data, centers=i)$withinss)
  }
  plot(1:nc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares")
}

wssplot(wineRevised)


# Exercise 2:
#   * How many clusters does this method suggest?
#   * Why does this method work? What's the intuition behind it?
#   * Look at the code for wssplot() and figure out how it works
# Method 2: Use the NbClust library, which runs many experiments
# and gives a distribution of potential number of clusters.

library(NbClust)
set.seed(1234)
nc <- NbClust(wineRevised, min.nc=2, max.nc=15, method="kmeans")
barplot(table(nc$Best.n[1,]),
	          xlab="Numer of Clusters", ylab="Number of Criteria",
		            main="Number of Clusters Chosen by 26 Criteria")

# QUESTION: WHY BARPLOT INSTEAD OF GGPLOT GEOM_BAR?

# Exercise 3: How many clusters does this method suggest?
# Here are the results from the NbClust function:
# Among all indices:                                                
# 4 proposed 2 as the best number of clusters 
# 15 proposed 3 as the best number of clusters 
# 1 proposed 10 as the best number of clusters 
# 1 proposed 12 as the best number of clusters 
# 1 proposed 14 as the best number of clusters 
# 1 proposed 15 as the best number of clusters 
# THEREFORE: The majority suggests 3 clusters.

# Exercise 4: Once you've picked the number of clusters, run k-means 
# using this number of clusters. Output the result of calling kmeans()
# into a variable fit.km

fit.km <- kmeans(wineRevised, centers=3)
summary(fit.km)
fit.km$size
fit.km$centers
fit.km$withinss
fit.km$totss

# Now we want to evaluate how well this clustering does.

# Exercise 5: using the table() function, show how the clusters in fit.km$clusters
# compares to the actual wine types in wine$Type. Would you consider this a good
# clustering?

wineCompare <- table(actual=wine$Type, predict=fit.km$cluster)
wineCompare


# The table output for wineCompare appears to show that these are good clusters.
# Here is the output
# 1  2  3
# 1  0  0 59
# 2  3 65  3
# 3 48  0  0

# Exercise 6:
# * Visualize these clusters using  function clusplot() from the cluster library
# * Would you consider this a good clustering?

library(cluster)
clusplot(wine, fit.km$cluster)

# There appear to be a few outliers, but otherwise looks good.

