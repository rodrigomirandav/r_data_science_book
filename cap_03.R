# Instalação dos pacotes
#install.packages("tidyverse")
#install.packages("nycflights13")

# Importação bibliotecas
library(tidyverse)
library(nycflights13)

# Cap 03 - Transformação dos Dados com dplry

# Arquivo de vôos de NYC em 2013
View(flights)

# Dplyr:
#   Filter
#   Arrange
#   Select
#   Mutate
#   summarize


#### Filter

# Filtrando dia 01/01
(jan1 <- filter(flights, month == 1, day == 1))
# Filtrando dia 25/12
(dec25 <- filter(flights, month == 12, day == 25))

# Comparação de ponto flutuante, não usar o ==, usar o near
# True
near(sqrt(2) ^2, 2)
# False, por causa da precisão do ponto flutuante, depende de computador para computador
sqrt(2) ^2 == 2

# Vôos nomvrembro e dezembro
nov_dec <- filter(flights, month %in% c(11,12));nov_dec

# Usando operador de and, or, not
delay120 <- filter(flights, dep_delay <= 120 & arr_delay <= 120);delay120

# filtrando NA (Not at number)
dep_delay_na <- filter(flights, is.na(dep_delay));dep_delay_na
not_dep_delay_na <- filter(flights, !is.na(dep_delay));not_dep_delay_na


## Praticando
?flights
# 1) Encontrar todos os voos que:
# a) Tiveram atrasos de 2 horas ou mais na chegada
voo_delayed_more_120 <- filter(flights, arr_delay >= 120);voo_delayed_more_120

# b) Foram para Houston (IAH ou HOU)
houston <- filter(flights, dest %in% c("IAH","HOU"));houston
View(houston)               

# c) Foram operados por United ?, American e Delta
operadoras <- filter(flights, carrier %in% c("AA","UA","DL"));operadoras

# d) Partiram em julho, agosto, setembro
departure_jul_aug_sep <- filter(flights, month %in% c(7,8,9));departure_jul_aug_sep

# e) Chegaram mais de duas horas atraso, mas não sairam atrasado
delay_e <- filter(flights, arr_delay >= 120 & dep_delay <= 0) ;delay_e

# f) Atraso de pelo menos 1 horas, mas compensou mais de 30 minutos na chegada
delay_f <- filter(flights, dep_delay >= 60 & arr_delay  <= 30);delay_f

# g) Saida entre meia noite e 6 da manhã
saida_12_6 <- filter( flights, (dep_time %/% 100) >= 0 & (dep_time %/% 100) <= 6);saida_12_6

# 3
# dep_time faltante
dep_time_na <- filter(flights, is.na(dep_time)); count(dep_time_na)
