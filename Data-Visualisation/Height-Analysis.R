library(dslabs)
library(dplyr)
library(ggplot2)
library(gridExtra)
data(heights)

#filter data between males and females
male = heights %>% filter(sex == "Male")
female = heights %>% filter(sex == "Female")

#calculating the mean and standard deviation
maleParams = male %>% summarize(mean = mean(height), sd = sd(height))
femaleParams = female %>% summarize(mean = mean(height), sd = sd(height))

#male's histogram
p1 = male %>% ggplot(aes(x = height))  + 
  geom_histogram(aes(y = after_stat(density)), binwidth = 1, fill = "blue", col = "black") +
  geom_density(col = "red", linewidth = 0.75) +
  xlab("Male's height in inches") +
  ggtitle("Histogram")

#male's Q-Q plot
p2 = male %>% ggplot(aes(sample = height))  + 
  geom_qq(dparams = maleParams) +
  geom_abline() +
  ggtitle("Male's height Q-Q plot")

#female's histogram
p3 = female %>% ggplot(aes(x = height))  + 
  geom_histogram(aes(y = after_stat(density)), binwidth = 1, fill = "blue", col = "black") +
  geom_density(aes (x = height), color = "red", linewidth = 0.75) +
  xlab("Female's height in inches") +
  ggtitle("Histogram")

#female's Q-Q plot
p4 = female %>% ggplot(aes(sample = height))  + 
  geom_qq(dparams = femaleParams) +
  geom_abline() +
  ggtitle("Female's height Q-Q plot")

#combining all the graphs together
grid.arrange(p1, p2, p3, p4, ncol = 2, nrow = 2)

