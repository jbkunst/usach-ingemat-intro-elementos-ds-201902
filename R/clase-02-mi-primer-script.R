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

nchar(url)

data <- read_tsv(url)

glimpse(data)
