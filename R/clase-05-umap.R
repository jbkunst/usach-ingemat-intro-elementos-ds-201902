library(tidyverse)
library(umap)

dori <- read_tsv("https://raw.githubusercontent.com/jbkunst/usach-ingemat-intro-elementos-ds-201902/master/data/encuesta.txt")
data <- read_tsv("https://raw.githubusercontent.com/jbkunst/usach-ingemat-intro-elementos-ds-201902/master/data/encuesta_hotencoding.txt")


glimpse(dori)

scale(1:10)

data <- data %>% 
  scale() %>% 
  as_data_frame()

dumap <- umap(data)

# pasar a dataframe 
dumap2 <- dumap$layout %>% 
  as_data_frame() %>% 
  as_tibble()


ggplot(dumap2) +
  geom_point(aes(x = V1, y = V2))


dumap2 <- dumap2 %>% 
  mutate(
    nombre = dori$email_address
  )

dumap2

library(ggrepel)

ggplot(dumap2) +
  geom_point(aes(x = V1, y = V2)) +
  geom_text_repel(aes(x = V1, y = V2, label = nombre), force = 10)
