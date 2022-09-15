library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(rvest)

url = "https://en.wikipedia.org/wiki/Murder_in_the_United_States_by_state"

h = read_html(url)

murders = h %>% html_nodes("table") %>% html_table() %>% .[[4]] %>%
  setNames(c("state", "population", "murder&menslaught", "murder", "gunMurders", "gunOwnership", "rate1", "rate2", "rate3")) %>%
  select(state, population, murder) %>%
  mutate(murder = parse_number(murder))
  

region_and_abb = data.frame(state = state.name, 
                            region = state.region,
                            abb = state.abb)

murders = inner_join(murders, region_and_abb, by = "state")

murders = data.frame(state = murders$state,
                     abb = murders$abb,
                     region = murders$region,
                     popolation = murders$population,
                     murder = murders$murder)

save(murders, file = "../Data/murders.rda")
