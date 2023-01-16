library(titanic)    # loads titanic_train data frame
library(caret)
library(dplyr)
library(rpart)

# 3 significant digits
options(digits = 3)
options(warn = -1)

# clean the data - `titanic_train` is loaded with the titanic package
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

# splitting the data into test set and train set
set.seed(42, sample.kind = "Rounding")
test_index = createDataPartition(titanic_clean$Survived, p = 0.2, list = FALSE)
test_set = titanic_clean[test_index,]
train_set = titanic_clean[-test_index,]

nb_observation_train = nrow(train_set)
nb_observation_test = nrow(test_set)
prop_survival = mean(train_set$Survived == 1)

# what accuracy we will get by guessing the survival of a given person?
# That will help us determine whether our machine learning algorithm performs better than chance
cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n")
set.seed(3, sample.kind = "Rounding")
random_guessing = sample(c(0, 1), nrow(test_set), replace = TRUE) %>% as.factor()
accuracy_guessing = confusionMatrix(random_guessing, test_set$Survived)$overall["Accuracy"]
cat("if we randomly guess the survivor, we obtain an accuracy of ")
cat(accuracy_guessing)
cat("\n\n")

# calculating proportion of survival stratified by sex from the train set
cat("# calculating proportion of survival stratified by sex from the train set\n")
prop_survival_male = train_set %>% filter(Sex == "male") %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion
cat("    * proportion of survival of male passengers ")
cat(prop_survival_male)
cat("\n")

prop_survival_female = train_set %>% filter(Sex == "female") %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion
cat("    * proportion of survival of female passengers ")
cat(prop_survival_female)
cat("\n")

# we see a clear difference in the proportion of survival between the two sexes
# what accuracy we will get by predicting survival of an individual based on his sex?
# since female are more likely to survive than males, we will predict a survival if an individual is a female, death otherwise.
sex_based_prediction = ifelse(test_set$Sex == "female", 1, 0) %>% as.factor() # a value of 1 indicates survival, 0 indicates death
accuracy_sex_based_prediction = confusionMatrix(sex_based_prediction, test_set$Survived)$overal["Accuracy"]
cat("we notice that the proportion of females survivers is higher than that of males,\n# if we predict survival based on sex we get an accuracy of ")
cat(accuracy_sex_based_prediction)
cat("\n\n")

# identifying if the passenger's class is a strong predictor
cat("# we will check if the passenger's class is a strong predictor or not \n")
prop_survival_class1 = train_set %>% filter(Pclass == 1) %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion
cat("    * proportion of survival of class 1 passengers ")
cat(prop_survival_class1)
cat("\n")

prop_survival_class2 = train_set %>% filter(Pclass == 2) %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion
cat("    * proportion of survival of class 2 passengers ")
cat(prop_survival_class2)
cat("\n")

prop_survival_class3 = train_set %>% filter(Pclass == 3) %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion
cat("    * proportion of survival of class 3 passengers ")
cat(prop_survival_class3)
cat("\n")

# calculating the accuracy of predictions based on the passenger's class
class_based_prediction = ifelse(test_set$Pclass == 1, 1, 0) %>% as.factor()
accuracy_class_based_prediction = confusionMatrix(class_based_prediction, test_set$Survived)$overall["Accuracy"]
cat("if we predict a survival for class 1 passengers and death otherwise, we get an accuracy of ")
cat(accuracy_class_based_prediction)
cat("\n\n")

# calculating the proportion of survival based on sex and the passenger's class
proportion_table = train_set %>% group_by(Pclass, Sex) %>% 
  summarize(proportion = mean(Survived == 1)) 

# calculating the accuracy of predictions based on the passenger's sex and class
class_sex_based_prediction = ifelse(test_set$Pclass %in% c(1, 2) & test_set$Sex == "female", 1, 0) %>% as.factor()
accuracy_class_sex_based_prediction = confusionMatrix(class_sex_based_prediction, test_set$Survived)$overall["Accuracy"]
cat("# if we use both predictors we get an accuracy of ")
cat(accuracy_class_sex_based_prediction)
cat("\n")
cat("we can see that the passenger's class is not as strong of a predictor as sex, and did not influence the result as much\n\n")

# calculating accuracy using the linear discriminant analysis method using fare as the only predictor
set.seed(1, sample.kind = "Rounding")
LDA_model = caret::train(Survived~Fare, data = train_set, method = "lda")
LDA_predictions = predict(LDA_model, test_set)
accuracy_LDA = mean(LDA_predictions == test_set$Survived)

# calculating accuracy using the quadratic discriminant analysis method using fare as the only predictor
set.seed(1, sample.kind = "Rounding")
QDA_model = caret::train(Survived~Fare, data = train_set, method = "qda")
QDA_predictions = predict(QDA_model, test_set)
accuracy_QDA = mean(QDA_predictions == test_set$Survived)

# calculating accuracy using the logistic regression method 
# using age as the only predictor
cat("# we will be testing the accuracy of logistic regression, with some predictors \n")
set.seed(1, sample.kind = "Rounding")
GLM_model1 = caret::train(Survived~Age, data = train_set, method = "glm")
GLM_predictions1 = predict(GLM_model1, test_set)
accuracy1_GLM = mean(GLM_predictions1 == test_set$Survived)
cat("    * predictors : Age; accuracy : ")
cat(accuracy1_GLM)
cat("\n")

# using sex, class, fare and age as predictors
set.seed(1, sample.kind = "Rounding")
GLM_model2 = caret::train(Survived ~ Sex+Pclass+Fare+Age, data = train_set, method = "glm")
GLM_predictions2 = predict(GLM_model2, test_set)
accuracy2_GLM = mean(GLM_predictions2 == test_set$Survived)
cat("    * predictors : sex, class, fare, age; accuracy : ")
cat(accuracy2_GLM)
cat("\n")

# with all predictors
set.seed(1, sample.kind = "Rounding")
GLM_model3 = caret::train(Survived~., data = train_set, method = "glm")
GLM_predictions3 = predict(GLM_model3, test_set)
accuracy3_GLM = mean(GLM_predictions3 == test_set$Survived)
cat("    * predictors : sex, class, age, fare, parch, familysize, embarked (all predictors); accuracy : ")
cat(accuracy3_GLM)
cat("\n\n")

# training a knn model, finding the optimal k value
set.seed(6, sample.kind = "Rounding")
knn_model = caret::train(Survived~., data = train_set, method = "knn", tuneGrid = data.frame(k = seq(3, 51, 2)))
best_value_knn = knn_model$bestTune

# plotting the variation of accuracy with respect to k (the number of neighbours)
ggplot(knn_model)

# accuracy of the knn model
knn_predictions = predict(knn_model, test_set)
accuracy_knn = mean(knn_predictions == test_set$Survived)
cat("# using a k-nearest-neighbours on all predictors, we get an accuracy of ")
cat(accuracy_knn)
cat("\n\n")

# training a knn model using 10 fold cross validation
set.seed(8, sample.kind = "Rounding")
control = trainControl(method = "cv", number = 10, p = .9)
knn_model2 = caret::train(Survived~., data = train_set, method = "knn", 
                          tuneGrid = data.frame(k = seq(3, 51, 2)),
                          trControl = control)
best_value2_knn = knn_model2$bestTune
knn_predictions2 = predict(knn_model2, test_set)
accuracy2_knn = mean(knn_predictions2 == test_set$Survived)

# training a decision tree model
set.seed(10, sample.kind = "Rounding")
rpart_model = caret::train(Survived~., data = train_set, method = "rpart", 
                          tuneGrid = data.frame(cp = seq(0, 0.05, 0.002)))
best_value_rpart = rpart_model$bestTune
rpart_predictions = predict(rpart_model, test_set)
accuracy_rpart = mean(rpart_predictions == test_set$Survived)
plot(rpart_model$finalModel, margin = 0.1)
text(rpart_model$finalModel, cex = 0.5)
cat("# using a decision tree model on all predictors, we get an accuracy of ")
cat(accuracy_rpart)
cat("\n\n")

# training a random forest model
#set.seed(14, sample.kind = "Rounding")
#rf_model = caret::train(Survived~., data = train_set, method = "rf",
#                        tuneGrid = data.frame(mtry = seq(1:7)),
#                        ntree = 100)
#nobest_value_rf = rf_model$bestTune
#rf_predictions = predict(rf_model, test_set)
#accuracy_rf = mean(rf_predictions == test_set$Survived)
#imp = varImp(rf_model)
#sortImp(imp, 1)
cat("we get the highest accuracy in this program from the logistic regression model \n")