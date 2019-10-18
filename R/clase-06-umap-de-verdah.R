# install.packages("tidyverse")
library(tidyverse)

data <- read_csv("https://raw.githubusercontent.com/cerndb/dist-keras/master/examples/data/mnist.csv")

# data %>%
#   head(10) %>% 
#   View()

# sacar una fila
df <- data %>% 
  filter(row_number() == 15+12321)

# View(df)

dfg <- df %>% 
  gather(pixel, valor, -label) %>% 
  mutate(lito = str_extract(pixel, "[0-9]+")) %>% 
  mutate(lito = as.numeric(lito) + 1) %>% 
  mutate(fila = ceiling(lito/28)) %>% 
  mutate(colu = lito%%28)

ggplot(dfg) +
  geom_tile(aes(x = -colu, y = fila, fill =valor)) 


graficar_numero <- function(ids = c(10, 20, 30)) {
  data %>% 
    mutate(id = row_number()) %>% 
    filter(id %in% ids) %>% 
    gather(pixel, valor, -label, -id) %>% 
    mutate(lito = str_extract(pixel, "[0-9]+")) %>% 
    mutate(lito = as.numeric(lito) + 1) %>% 
    mutate(fila = ceiling(lito/28)) %>% 
    mutate(colu = lito%%28) %>% 
    ggplot() +
    geom_tile(aes(x = colu, y = -fila, fill = valor)) +
    facet_wrap(vars(label, id))
  
}

graficar_numero(c(10, 20, 55, 40000))

graficar_numero(c(10, 200, 550, 42000))

# mejor una funcion oe!

# ahora umap --------------------------------------------------------------
# remotes::install_github("jlmelville/uwot")
# https://github.com/jlmelville/uwot#performance
library(uwot)


mnist_umap <- umap(data %>% select(-label), n_threads = 10, approx_pow = TRUE, pca = 50)

mnist_umap <- mnist_umap %>% 
  as_tibble() %>% 
  bind_cols(data %>% select(label)) %>% 
  mutate(
    label = as.character(label),
    id = row_number()
    )


ggplot(mnist_umap, aes(x = V1, y = V2)) +
  geom_point(alpha = 0.5, size = .5) +
  scale_color_viridis_d() +
  theme_void()


ggplot(mnist_umap, aes(x = V1, y = V2)) +
  geom_point(aes(color = label), alpha = 0.5, size = 0.5) +
  scale_color_viridis_d() +
  theme_void() +
  theme(legend.position = "bottom")


# deteccion de casos raros ------------------------------------------------
# install.packages("dbscan")
library(dbscan)

res <- dbscan::dbscan(mnist_umap %>% select(1:2), eps = .8, minPts = 500)
res

mnist_umap <- mnist_umap %>% 
  mutate(cluster = as.character(res$cluster))

ggplot(mnist_umap, aes(x = V1, y = V2)) +
  geom_point(aes(color = cluster), alpha = 0.5, size = 2) +
  scale_color_viridis_d() +
  theme_void() +
  theme(legend.position = "bottom")


cluster <- mnist_umap %>% 
  group_by(label, cluster) %>% 
  count(sort = TRUE) %>% 
  head(10) %>% 
  ungroup() %>% 
  mutate(n = TRUE)

mnist_umap <- mnist_umap %>% 
  left_join(cluster)
  
mnist_umap <- mnist_umap %>% 
  mutate(n = replace_na(n, FALSE))

mnist_umap %>% 
  count(n)

mnist_umap %>% 
  filter(!n) %>% 
  sample_n(9) %>% 
  pull(id) %>% 
  graficar_numero()


# plot --------------------------------------------------------------------
library(ggforce)



ggplot(mnist_umap, aes(x = V1, y = V2)) +
  geom_point(aes(color = label), alpha = 0.5, size = 0.5) +
  geom_mark_ellipse(
    aes(group = label, label = label),
    data = mnist_umap %>% ungroup() %>% filter(n) %>% group_by(label) %>% sample_frac(0.5) %>% filter(abs(scale(V1)) < 2, abs(scale(V2)) < 2)
    ) + 
  scale_color_viridis_d() +
  theme_void() +
  theme(legend.position = "none")


filter(mnist_umap, n) %>% count(label, cluster)
filter(mnist_umap, n) %>% count(label)
