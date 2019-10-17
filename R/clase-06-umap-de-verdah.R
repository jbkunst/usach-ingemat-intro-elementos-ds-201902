# install.packages("tidyverse")
library(tidyverse)

data <- read_csv("https://raw.githubusercontent.com/cerndb/dist-keras/master/examples/data/mnist.csv")
data %>%
  select(1:10)
