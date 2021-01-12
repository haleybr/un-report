library(tidyverse)

gapminder_data <- read_csv("data/gapminder_data.csv")
View(gapminder_data)


summarize(gapminder_data, mean(lifeExp))

# label column name
summarize(gapminder_data, averageLifeExp = mean(lifeExp))

# piping function: %>% allows you make chain of code. ie do some num crunching of the mean
gapminder_data %>% summarize(averageLifeExp = mean(lifeExp))

# Exercise: find the mean population and most recent year
gapminder_data %>% summarize(averagePopulation = mean(pop), recent_year = max(year))

# filter allows selection of specific rows in data. filters rows where year is 2007.
gapminder_data %>% filter(year == 2007)

# determine life exp in 2007
gapminder_data %>% filter(year == 2007) %>% summarize(averageLifeExpectancy = mean(lifeExp))

# Exercise find the average GDP per capita for the first year in the dataset
gapminder_data %>% summarize(first_year = min(year)) #1952
gapminder_data %>% 
  filter(year == 1952) %>% 
  summarize(averageGDPpercapita = mean(gdpPercap), first_year = min(year))

# we can use >, <, >=, <= for filtering

# group_by: mean lifeExp by year
gapminder_data %>% 
  group_by(year) %>% 
  summarize(averageLifeExp = mean(lifeExp))
# year and lifeExp are not in quotes because they are column names

# Exercise: find the mean life expectancy for each continent

gapminder_data %>% 
  group_by(continent) %>% 
  summarize(averageLifeExp = mean(lifeExp))

# mutate - add more columns to your dataset. Find total GDP.
gapminder_data %>% 
  mutate(gdp = gdpPercap * pop)

# Exercise: make a new column that is population in millions
gapminder_data %>% 
  mutate(pop_in_millions = pop / 1000000)

# select() - specify which columns we want to keep
gapminder_data %>% 
  select(year, pop)

# get rid of a single column
gapminder_data %>% 
  select(-continent)

# select() - specify which columns we want to keep and make an object
year_pop <- gapminder_data %>% 
  select(year, pop)

# Exercise: want country, continent, year, and lifeExp columns
gapminder_data %>% 
  select(country, continent, year, lifeExp)

gapminder_data %>% 
  select(-gdpPercap, -pop)

# arrange, starts with, ways to organize data

# long vs. wide shaped dataframe. change it from long to wide. pivot_longer and pivot_wider

gapminder_data %>% 
  select(country, continent, year, lifeExp) %>% 
  pivot_wider(names_from = year, values_from = lifeExp)

# rename() to rename columns

# Exercise: Create a new dataset with only data from the Americas and 2007
# drop the continent and year columns
gapminder_Americas_2007 <- gapminder_data %>%
  filter(year == 2007, continent == "Americas") %>% 
  select(-continent, -year)

gapminder_data <- read_csv("data/gapminder_data.csv") %>%
  filter(year == 2007, continent == "Americas") %>% 
  select(-continent, -year)





