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

# dealing with extra columns
read_csv("data/co2-un-data.csv", skip = 2,
         col_names = c("region", "country", "year", "series", "value", 
                       "footnotes", "source"))

# Goals: data from a year that is close to 2007
# A column for country and we want columns for different types of CO2 emissions (total, per capita)

# Exercise: select only the country, year, series, value, rename series columns

co2_emissions <- read_csv("data/co2-un-data.csv", skip = 2,
         col_names = c("region", "country", "year", "series", "value", 
                       "footnotes", "source")) %>% 
  select(country, year, series, value) %>% 
  mutate(series = recode(series, 
                         "Emissions (thousand metric tons of carbon dioxide)" = "total_emissions",
                         "Emissions per capita (metric tons of carbon dioxide)" = "per_capita_emissions")) %>% 
  pivot_wider(names_from = series, values_from = value) %>% 
  filter(year == 2005) %>% 
  select(-year) %>% 
  mutate(country = recode( country,
                           "Bolivia (Plurin. State of)" = "Bolivia",
                           "United States of America" = "United States",
                           "Venezuela (Boliv. Rep. of)" = "Venezuela"))

View(co2_emissions)

# joining with the gapminder dataset. country is the key value by which to join the datasets
# inner_join would only keep similar countries between both, outer would keep everything

inner_join(gapminder_data, co2_emissions, by = "country")

# could do
gapminder_data %>% inner_join(co2_emissions, by = "country")

# tell you what is in the first dataset that's not in the second. Bolivia is referred to differently
anti_join(gapminder_data, co2_emissions)

# change PR to be a part of the US
gapminder_data <- read_csv("data/gapminder_data.csv") %>%
  filter(year == 2007, continent == "Americas") %>% 
  select(-continent, -year) %>% 
  mutate(country = recode(country, "Puerto Rico" = "United States")) %>% 
  group_by(country) %>% 
  summarize(lifeExp = sum(lifeExp * pop)/sum(pop),
            gdpPercap = sum(gdpPercap * pop)/ sum(pop),
            pop = sum(pop))

View(gapminder_data)

anti_join(gapminder_data, co2_emissions) # check that everything matches

gapminder_co2 <- inner_join(gapminder_data, co2_emissions, by = "country")
View(gapminder_co2)

# using mutate and the if_else function together
# if_else(conidition, true, false)
gap_co2_region <- gapminder_co2 %>% 
  mutate(region = if_else(country == "Canada" | country == "United States" | country == "Mexico",
                          "north", "south"))
View(gap_co2_region)

# | - or
# && - and
# ! - not

# is there a relationship between gdp and co2 emissions

# exercise: create a scatter plot of gdp vs co2 emissions, color it by region

ggplot(data = gap_co2_region) +
  aes(x = gdpPercap, y = per_capita_emissions, color = region) +
  labs(x = "Gdp Per Capit", y = "Emissions") +
  geom_point()

gap_co2_region %>% ggplot() +
  aes(x = gdpPercap, y = per_capita_emissions, color = region) +
  labs(x = "Gdp Per Capit", y = "Emissions") +
  geom_point()
