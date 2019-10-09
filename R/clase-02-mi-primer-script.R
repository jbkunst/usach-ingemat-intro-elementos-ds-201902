# aca van las instrucciones

# por ej asignacion 
# la combinaciòn magina CTRL+ENTER
x <- 4

# paquetes:
# 
plot(cumsum(rnorm(100)), type = "l")

# primer paquete a instalar el "tidyverse":
# es una coleccion de paquetes
# install.packages("tidyverse")
library(tidyverse)

url <- "https://docs.google.com/spreadsheets/d/1amKJa4Ua4qO87z3OL-OEv3EznanqOoTy0L-NUimoowM/export?format=tsv&id=1amKJa4Ua4qO87z3OL-OEv3EznanqOoTy0L-NUimoowM&gid=2134224185"

url

# nchar(url)

data <- read_tsv(url)

glimpse(data)


# cambiar nombres ---------------------------------------------------------
data <- data %>% 
  rename_all(str_replace_all, " ", "_") %>% 
  rename_all(str_remove_all, "\\?") %>% 
  rename_all(str_remove_all, "!") %>% 
  rename_all(stringi::stri_trans_general, id = "Latin-ASCII") %>% 
  rename_all(str_to_lower)

glimpse(data)
    
# x <- "asdasdf arasdfa ert@zsv.cl weadfasd wer@sdf.quetimpornta"
# 
# str_extract_all(x, "[a-z]+@[a-z]+\\.[a-z]+")


# que edad tenemos --------------------------------------------------------
# - necesitamos que la variable sea interpretada como fecha
library(lubridate)

class(mdy("2/22/1995"))

data <- data %>% 
  mutate(fecha_de_nacimiento = mdy(fecha_de_nacimiento))

glimpse(data)


as.numeric(difftime(Sys.Date(), mdy("2/22/1995"), unit="weeks"))/52.25


data <- data %>% 
  mutate(edad = as.numeric(difftime(Sys.Date(), fecha_de_nacimiento, unit="weeks"))/52.25
)

glimpse(data)

data %>% 
  summarise(mean(edad, na.rm = TRUE))

dg1 <- data %>% 
  filter(ramo_que_mas_amo_en_la_vida == "Procesos estocásticos, estadística y probabilidad")



ggplot(data) +
  geom_point(aes(x = edad, ano_de_carrera, 
                 color = ramo_que_mas_amo_en_la_vida)) +
  facet_wrap(vars(ramo_que_mas_amo_en_la_vida))
