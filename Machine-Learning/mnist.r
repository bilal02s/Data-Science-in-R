library(dslabs)
library(dplyr)
library(caret)
library(Rborist)

mnist <- read_mnist()

# dividing data into train and test sets
indexTrain = sample(nrow(mnist$train$images), 10000, replace=FALSE)
indexTest = sample(nrow(mnist$test$images), 1000, replace=FALSE)

x = mnist$train$images[indexTrain,]
y = mnist$train$labels[indexTrain] %>% as.factor()

xTest = mnist$train$images[indexTest,]
yTest = mnist$train$labels[indexTest] %>% as.factor()

colnames(x) = 1:ncol(x)
colnames(xTest) = colnames(x)

# removing predictor with close to zero variance
cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n")
cat("# we start by creating a test set of 10000 image, and a training set of 1000 image\n\n")
cat("# removing predictors with close to zero variance\n")
toRemove = nearZeroVar(x)
xi = x[,-toRemove]
xiTest = xTest[,-toRemove]
cat("we have removed ");cat(length(toRemove));cat(" predictor out of 784\n\n")

# train a knn model
cat("# training a k-nearest-neighbou model, with k = 3\n")
knnModel = knn3(xi, y, k=3)
knnPredictions = predict(knnModel, xiTest)

# train a random forest model
cat("# training a random forest model, with number of tree = 1000\n\n")
rf = Rborist(xi, y, ntree=1000)
rfPredictions = predict(rf, xiTest, type="class")

rfProbs = rfPredictions$census/rowSums(rfPredictions$census)
knnProbs = knnPredictions

cat("Combining the two predictions by taking the average.\n\n")
yPredictions = (rfProbs + knnProbs)/2 
y_hatt = (apply(yPredictions, 1, which.max) -1)%>% as.factor()

cat("we get the following prediction on the test data\n\n")
matrix = confusionMatrix(y_hatt, yTest)
matrix$table
