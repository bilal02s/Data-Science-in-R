library(dslabs)
library(dplyr)
library(caret)

data(movielens)

# getting the indices for the test set
test_index = createDataPartition(movielens$rating, p = 0.2, list=FALSE)

# splitting the data into train and test sets
train_set = movielens[-test_index,]
test_set = movielens[test_index,]

# getting the average mean overall the train set ratings
avgRating = mean(train_set$rating)

# calculating the movie bias, a value unique to every movie
movieEffect = train_set %>% group_by(movieId) %>% 
  summarize(bi = sum(rating - avgRating)/(n() + 3))

# calculating the user bias, a value unique to every user
userEffect = train_set %>% left_join(movieEffect, by = "movieId") %>%
  mutate(bi = replace(bi, which(is.na(bi)), 0)) %>%
  group_by(userId) %>%
  summarize(bu = sum(rating - avgRating - bi)/(n() + 3))

# building the final model
predictions = test_set %>% left_join(movieEffect, by = "movieId") %>%
  mutate(bi = replace(bi, which(is.na(bi)), 0)) %>%
  left_join(userEffect, by = "userId") %>%
  mutate(bu = replace(bu, which(is.na(bu)), 0)) %>%
  mutate(pred = avgRating + bi + bu) %>% .$pred

# evaluation function
RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
}
RMSE(test_set$rating, predictions)

