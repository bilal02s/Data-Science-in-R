library(dslabs)
library(dplyr)
library(stringr)
library(tidyr)

data(reported_heights)

errors = reported_heights %>% mutate(numeric = as.numeric(height)) %>% 
  filter(is.na(numeric)) %>% .$height
errors

smallest = 50
tallest = 84
pattern = "^([4-7])\\s*'\\s*(\\d{1,2}\\.?\\d*)$"

convert_format = function(str){
  str %>% 
    str_replace_all("inches|inch|''|\"|cm", "") %>%
    str_replace_all("ft|foot|feet", "'") %>%
    str_trim() %>%
    str_replace_all("^([4-7])\\s*[,\\.\\*\\s+]\\s*(\\d*)$", "\\1'\\2") %>%
    str_replace_all("^([56])'?$", "\\1'0") %>%
    str_replace_all("^([12])\\s*,\\s*(\\d*)\\s*", "\\1\\.\\2")
}

wordsToNumbers = function(str){
  str %>%
    str_to_lower() %>%
    str_replace_all("zero", "0") %>%
    str_replace_all("one", "1") %>%
    str_replace_all("two", "2") %>%
    str_replace_all("three", "3") %>%
    str_replace_all("four", "4") %>%
    str_replace_all("five", "5") %>%
    str_replace_all("six", "6") %>%
    str_replace_all("seven", "7") %>%
    str_replace_all("eight", "8") %>%
    str_replace_all("nine", "9") %>%
    str_replace_all("ten", "10") %>%
    str_replace_all("eleven", "11") 
}

new_heights = reported_heights %>% 
  mutate(converted_height = wordsToNumbers(height) %>% convert_format()) %>%
  extract(converted_height, c("foot", "inch"), regex = pattern, remove = FALSE) %>% 
  mutate_at(c("converted_height", "foot", "inch"), as.numeric) %>%
  mutate(new_value = 12*foot + inch) %>%
  mutate(final_values = case_when(
    !is.na(converted_height) & between(converted_height, smallest, tallest) ~ converted_height,
    !is.na(converted_height) & between(converted_height/2.54, smallest, tallest) ~ converted_height/2.54,
    !is.na(converted_height) & between(converted_height*100/2.54, smallest, tallest) ~ converted_height*100/2.54,
    !is.na(new_value) & inch < 12 & between(new_value, smallest, tallest) ~ new_value,
    TRUE ~ as.numeric(NA))) %>%
  select(sex, final_values) %>%
  filter(!is.na(final_values)) 

colnames(new_heights)[2] = "height"
  
save(new_heights, file = "./heights.rda")






