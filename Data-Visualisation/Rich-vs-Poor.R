library(tidyverse)
library(dplyr)
library(ggplot2)
library(gridExtra)
data(gapminder)

#calculating the average income distribution, which is equal to the total yearly gdp country divided by the population and 365 days
gapminder = gapminder %>% mutate(dollars_per_day = gdp/population/365)

p1 = gapminder %>% filter(year == 1970 & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, fill = "darkgrey", col = "black") +
  scale_x_continuous(trans = "log2") +
  xlab("average income (dollars per day)") +
  ggtitle("average income distribution (plot 1)")

p2 = gapminder %>% filter(year == 1970 & !is.na(gdp)) %>%
  mutate(region = reorder(region, dollars_per_day, median)) %>%
  ggplot(aes(x = region, y = dollars_per_day, fill = continent))+
  geom_boxplot() +
  scale_y_continuous(trans = "log2") +
  xlab("") +
  ylab("average income (dollars_per_day)") +
  ggtitle("average income distribution across regions in 1970 (plot 2)") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#creating the seperate groups of countries (rich and poor)
west = c("Southern Europe", "Western Europe", "Northern Europe", "Northern America", "Australia and New Zealand")

countries_list1 = gapminder %>% filter(year == 1970 & !is.na(dollars_per_day)) %>% .$country
countries_list2 = gapminder %>% filter(year == 2010 & !is.na(dollars_per_day)) %>% .$country
common_countries = intersect(countries_list1, countries_list2)

p3 = gapminder %>% filter(year %in% c(1970, 2010) & !is.na(gdp) & country %in% common_countries) %>%
  mutate( region = reorder(region, dollars_per_day, median)) %>%
  ggplot(aes(region, dollars_per_day, fill = factor(year))) +
  scale_y_continuous(trans = "log2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_boxplot()

p4 = gapminder %>% filter(year %in% c(1970, 2010) & !is.na(gdp) & country %in% common_countries) %>%
  mutate(group = ifelse(region %in% west, "West", "Developping"), region = reorder(region, dollars_per_day, median)) %>%
  ggplot(aes(dollars_per_day)) +
  scale_x_continuous(trans = "log2") +
  geom_histogram(binwidth = 1, col = "black") +
  xlab("average income (dollars per day)") +
  #ggtitle("average income comparison 1970-2010 (plot 3)")
  facet_grid(year~group)

p5 = gapminder %>% filter(year %in% c(1970, 2010) & country %in% common_countries) %>%
  summarize(continent = continent[year == 2010], region = region[year == 2010], ratio = dollars_per_day[year == 2010]/dollars_per_day[year == 1970]) %>%
  mutate(region = reorder(region, ratio, median)) %>%
  ggplot(aes(region, ratio, fill = continent)) +
  geom_boxplot() +
  scale_y_continuous(trans = "log2") +
  xlab("") +
  ylab("average income ratio") +
  ggtitle("average income ratio between 1970 and 2010")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

p1
p2
p4
p5




        