library(tidyverse)
library(dplyr)
library(ggplot2)
data(gapminder)

gapminder %>% filter(year %in% c(1962, 2012)) %>% 
  ggplot(aes(x = fertility, y = life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(.~year)
