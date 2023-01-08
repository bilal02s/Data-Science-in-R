library(dslabs)
library(caret)
library(Rborist)

mnist <- read_mnist()

indexTrain = sample(nrow(mnist$train$images), 10000, replace=FALSE)
indexTest = sample(nrow(mnist$test$images), 1000, replace=FALSE)

x = mnist$train$images[indexTrain,]
y = mnist$train$labels[indexTrain] %>% as.factor()

xTest = mnist$train$images[indexTest,]
yTest = mnist$train$labels[indexTest] %>% as.factor()

colnames(x) = 1:ncol(x)
colnames(xTest) = colnames(x)

toRemove = nearZeroVar(x)
xi = x[,-toRemove]
xiTest = xTest[,-toRemove]

knnModel = knn3(xi, y, k=3)
knnPredictions = predict(knnModel, xiTest)

rf = Rborist(xi, y, ntree=1000)
rfPredictions = predict(rf, xiTest, type="class")

rfProbs = rfPredictions$census/rowSums(rfPredictions$census)
knnProbs = knnPredictions

yPredictions = (rfProbs + knnProbs)/2 
y_hatt = (apply(yPredictions, 1, which.max) -1)%>% as.factor()

confusionMatrix(y_hatt, yTest)
