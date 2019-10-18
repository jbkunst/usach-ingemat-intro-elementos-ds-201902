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
# remotes::install_github("jlmelville/uwot")
# https://github.com/jlmelville/uwot#performance
library(uwot)
library(ggforce)

mnist_umap <- umap(data %>% select(-label), n_threads = 10, approx_pow = TRUE, pca = 50)

mnist_umap <- mnist_umap %>% 
  as_tibble() %>% 
  bind_cols(data %>% select(label)) %>% 
  mutate(label = as.character(label))


ggplot(mnist_umap, aes(x = V1, y = V2)) +
  geom_point(aes(color = label), alpha = 0.6, size = .8) +
  geom_mark_ellipse(aes(fill = label, label = label),  0.001) +
  scale_color_viridis_d() +
  theme_minimal()
