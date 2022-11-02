library(titanic)    # loads titanic_train data frame
library(caret)
library(tidyverse)
library(rpart)

# 3 significant digits
options(digits = 3)

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
set.seed(3, sample.kind = "Rounding")
random_guessing = sample(c(0, 1), nrow(test_set), replace = TRUE) %>% as.factor()
accuracy_guessing = confusionMatrix(random_guessing, test_set$Survived)$overall["Accuracy"]

# calculating proportion of survival stratified by sex from the train set
prop_survival_male = train_set %>% filter(Sex == "male") %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion

prop_survival_female = train_set %>% filter(Sex == "female") %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion

# we see a clear difference in the proportion of survival between the two sexes
# what accuracy we will get by predicting survival of an individual based on his sex?
# since female are more likely to survive than males, we will predict a survival if an individual is a female, death otherwise.
sex_based_prediction = ifelse(test_set$Sex == "female", 1, 0) %>% as.factor() # a value of 1 indicates survival, 0 indicates death
accuracy_sex_based_prediction = confusionMatrix(sex_based_prediction, test_set$Survived)$overal["Accuracy"]

# identifying if the passenger's class is a strong predictor
prop_survival_class1 = train_set %>% filter(Pclass == 1) %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion

prop_survival_class2 = train_set %>% filter(Pclass == 2) %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion

prop_survival_class3 = train_set %>% filter(Pclass == 3) %>%
  summarize(proportion = mean(Survived == 1)) %>% .$proportion

# calculating the accuracy of predictions based on the passenger's class
class_based_prediction = ifelse(test_set$Pclass == 1, 1, 0) %>% as.factor()
accuracy_class_based_prediction = confusionMatrix(class_based_prediction, test_set$Survived)$overall["Accuracy"]

# calculating the proportion of survival based on sex and the passenger's class
proportion_table = train_set %>% group_by(Pclass, Sex) %>% 
  summarize(proportion = mean(Survived == 1)) 

# calculating the accuracy of predictions based on the passenger's sex and class
class_sex_based_prediction = ifelse(test_set$Pclass %in% c(1, 2) & test_set$Sex == "female", 1, 0) %>% as.factor()
accuracy_class_sex_based_prediction = confusionMatrix(class_sex_based_prediction, test_set$Survived)$overall["Accuracy"]

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
