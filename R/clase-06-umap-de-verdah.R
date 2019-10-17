# install.packages("tidyverse")
library(tidyverse)

data <- read_csv("https://raw.githubusercontent.com/cerndb/dist-keras/master/examples/data/mnist.csv")
data %>%
  head(10) %>% 
  View()

# sacar una fila
df <- data %>% 
  filter(row_number() == 15+12321)

View(df)

dfg <- df %>% 
  gather(pixel, valor, -label) %>% 
  mutate(lito = str_extract(pixel, "[0-9]+")) %>% 
  mutate(lito = as.numeric(lito) + 1) %>% 
  mutate(fila = ceiling(lito/28)) %>% 
  mutate(colu = lito%%28)

ggplot(dfg) +
  geom_tile(aes(x = -colu, y = fila, fill =valor)) 



# ahora umap --------------------------------------------------------------
library(smallvis)

umap_iris <- smallvis(
  data %>% select(-label),
  method = "umap"
  )

dumap <- umap(data %>% select(-label))

# pasar a dataframe 
dumap2 <- dumap$layout %>% 
  as_data_frame() %>% 
  as_tibble()


ggplot(dumap2) +
  geom_point(aes(x = V1, y = V2))
