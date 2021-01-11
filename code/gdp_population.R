# load tidyverse packages
library(tidyverse)
# read in data
# assigning to objects, "read_csv" is a function, arrow stores what the function read into what it's called on the left. can't start with a number only a letter. no spaces.
# don't give same object name. See example below.
name <- "Ben"
name
age <- 26
age
name <- "Harry Potter"
name
gapminder_1997 <- read_csv("data/gapminder_1997.csv")
#learn more about a function
?read_csv
read_csv(file = "data/gapminder_1997.csv")
# just prints out the data. doesn't put into object because no arrow.
ggplot(data = gapminder_1997)
# doesn't work because you didn't tell it what variables to use etc.
ggplot(data = gapminder_1997) +
  aes(x = gdpPercap) +
  labs(x = "GDP Per Capita")
# needs to be parentheses because it's not in the data
# Exercise: add life expectancy to y axis and give it a label
ggplot(data = gapminder_1997) +
  aes(x = gdpPercap) +
  labs(x = "GDP Per Capita") +
  aes( y = lifeExp) + 
  labs(y = "Life Expectancy") +
  labs(title = "Do people in wealthy countries live longer?") +
  geom_point() +
  aes(color = continent) +
  scale_color_brewer(palette = "Set1") +
  aes(size = pop/1000000) +
  labs(size = "Population (in millions)")+
  aes(shape = continent)

# different color palettes
RColorBrewer::display.brewer.all()

# change data point shape
?aes

ggplot(data = gapminder_1997) +
  aes(x = gdpPercap, y = lifeExp, color = continent, size = pop/1000000) +
  labs(x = "GDP Per Capita", y = "Life Expectancy", title = "Do people in wealthy countries live longer?",
       size = "Population (in millions)") +
  geom_point() +
  scale_color_brewer(palette = "Set1")

# collapse code to make more concise
ggplot(data = gapminder_1997, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop/1000000)) +
  labs(x = "GDP Per Capita", y = "Life Expectancy", title = "Do people in wealthy countries live longer?",
       size = "Population (in millions)") +
  geom_point() +
  scale_color_brewer(palette = "Set1")

# read in full dataset
gapminder_data <- read_csv("data/gapminder_data.csv")
gapminder_data
dim(gapminder_data)
ggplot(data = gapminder_data) +
  aes(x = year, y = lifeExp, color=continent) +
  geom_line()
# right now it's connecting by continent. Looks like garbage. Add group below.

ggplot(data = gapminder_data) +
  aes(x = year, y = lifeExp, color=continent, group = country) +
  geom_line()

#plot categorical variables
# use gapminder_1997 data with geom_boxplot() to make a boxplot where continent is the x axis and life expectancy is the y axis

ggplot(data = gapminder_1997) +
  aes (x = continent, y = lifeExp) +
  geom_boxplot() +
  labs (x = "Continent", y = "Life Expectancy (years)")

# how to view as an object
View(gapminder_data)

# layering in different plots, order matters. this looks bad b/c violin is blocking jitter
ggplot(data = gapminder_1997) +
  aes (x = continent, y = lifeExp) +
  geom_jitter() +
  geom_violin() +
  labs (x = "Continent", y = "Life Expectancy (years)")
  
# can add different aes for each geom
ggplot(data = gapminder_1997) +
  aes (x = continent, y = lifeExp) +
  geom_jitter(aes(size=pop)) +
  geom_violin(alpha=0.5) +
  labs (x = "Continent", y = "Life Expectancy (years)")

ggplot(data = gapminder_1997, aes(fill = continent)) +
  aes (x = continent, y = lifeExp) +
  geom_jitter(aes(size=pop)) +
  geom_violin(alpha=0.5) +
  labs (x = "Continent", y = "Life Expectancy (years)")

ggplot(data = gapminder_1997) +
  aes (x = continent, y = lifeExp) +
  geom_jitter(aes(size=pop)) +
  geom_violin(alpha=0.5, aes(fill = continent)) +
  labs (x = "Continent", y = "Life Expectancy (years)")

# univariate plots

ggplot(gapminder_1997) +
  aes(x = lifeExp) +
  geom_histogram()

# deal with bin width and background
my_awesome_plot <- ggplot(gapminder_1997) +
  aes(x = lifeExp) +
  labs(x = "Life Expectancy", y = "# of Countries") +
  geom_histogram(bins = 20) +
  theme_classic()

#rotate x axis labels 90 degrees
ggplot(gapminder_1997) +
  aes(x = lifeExp) +
  labs(x = "Life Expectancy") +
  geom_histogram(bins = 20) +
  theme_classic() + theme(axis.text.x = element_text(angle= 90, hjust = 1, vjust = 0.5))

# saving plots, can use export

ggsave("figures/awesome_plot.jpg", width = 6, height = 4)

# store a plot in an object
violin_plot <- ggplot(data = gapminder_1997) +
  aes (x = continent, y = lifeExp) +
  geom_jitter(aes(size=pop)) +
  geom_violin(alpha=0.5, aes(fill = continent)) +
  labs (x = "Continent", y = "Life Expectancy (years)")

violin_plot +theme_bw()

# save theme
violin_plot <- violin_plot +theme_bw()
violin_plot

ggsave("figures/awesome_violin_plot.jpg", plot = violin_plot, width = 6, height = 4)

# Faceting plots
ggplot(gapminder_1997) +
  aes(x = gdpPercap, y = lifeExp) +
  geom_point() +
  facet_wrap(vars(continent))

# practice saving a plot as "my_awesome_plot.jp"
my_awesome_plot <- ggplot(gapminder_1997) +
  aes(x = lifeExp) +
  labs(x = "Life Expectancy", y = "# of Countries") +
  geom_histogram(bins = 20) +
  theme_classic()

my_awesome_plot
ggsave("figures/my_awesome_plot.jpg", plot = my_awesome_plot, width = 6, height = 4)
