# la siguiente linea pregunta si está
# instalada el paquete, si no lo instala
if(!require(tidyverse)) install.packages("tidyverse")

# comenzar a usarlo 
library(tidyverse)

url <- "https://docs.google.com/spreadsheets/d/1amKJa4Ua4qO87z3OL-OEv3EznanqOoTy0L-NUimoowM/export?format=tsv&id=1amKJa4Ua4qO87z3OL-OEv3EznanqOoTy0L-NUimoowM&gid=2134224185"
url

data <- read_tsv(url)

glimpse(data)

# la separación se hace con: CTRL + SHIFT + R (mano izq)
# la limpieza de nombres --------------------------------------------------
data <- data %>% 
  rename_all(stringi::stri_trans_general, id = "Latin-ASCII") %>% 
  rename_all(str_replace_all, " ", "_") %>% 
  rename_all(str_remove_all, "\\?|\\!") %>% 
  rename_all(str_to_lower)

glimpse(data)

# ejemplo de renombrar
df <- as_tibble(head(iris))
df

df %>% 
  rename(especie = Species) # renombrar

df %>% 
  mutate(especie = Species) # mutar, por favor! notar 🙏
# podemos crear nuevas colunas🙏

# transformación de variables ---------------------------------------------
library(lubridate)

data <- data %>% 
  mutate(
    fecha_nac = mdy(fecha_de_nacimiento),
    edad = year(Sys.Date()) - year(fecha_nac)
    )
 
data %>% 
  select(edad, fecha_nac)

fecha_nac2 <- pull(data, fecha_nac)


# graficar ----------------------------------------------------------------
# https://www.sharpsightlabs.com/blog/r-package-think-about-visualization/

?geom_point

ggplot(data) +
  geom_point(aes(x = edad, y = ano_de_carrera))

ggplot(data) +
  geom_point(aes(x = edad, y = ano_de_carrera), alpha = 0.5)

ggplot(data) +
  geom_point(aes(x = edad, y = ano_de_carrera),
             position = position_jitter(width = 0.1, height = 0.1))


ggplot(data) +
  geom_point(aes(x = edad, y = ano_de_carrera,
                 color = que_crees_que_aprenderas_aca))


ggplot(data) +
  geom_point(aes(x = edad, y = ano_de_carrera,
                 color = que_crees_que_aprenderas_aca, size = 3))

ggplot(data) +
  geom_point(aes(x = edad, y = ano_de_carrera,
                 color = que_crees_que_aprenderas_aca), size = 3)

df_carga <- data %>% 
  count(ramo_que_mas_me_carga_en_la_vida)

df_carga

ggplot(df_carga) +
  geom_col(aes(x = ramo_que_mas_me_carga_en_la_vida, y = n))


# hola --------------------------------------------------------------------
library(ggrepel)

ggplot(data) +
  geom_point(
    aes(x = edad, y = ano_de_carrera, color = que_crees_que_aprenderas_aca),
    size = 3
    ) +
  scale_color_viridis_d() +
  geom_text_repel(
    aes(x = edad, y = ano_de_carrera, label = email_address),
    color = "gray20", size = 3, force = 10
    ) +
  theme_minimal() +
  theme(legend.position = "bottom")

library(plotly)

plotly::ggplotly()
# hola --------------------------------------------------------------------
df_hotencoding <- model.matrix(  ~ 0 +
    ramo_que_mas_me_carga_en_la_vida +
    ramo_que_mas_amo_en_la_vida +
    edad + 
    ano_de_carrera, data = data) %>% 
  as_tibble()


df_hotencoding <- df_hotencoding %>% 
  rename_all(stringi::stri_trans_general, id = "Latin-ASCII") %>% 
  rename_all(str_replace_all, " ", "_") %>% 
  rename_all(str_remove_all, "\\?|\\!|\\,") %>% 
  rename_all(str_to_lower)

glimpse(df_hotencoding)

  
