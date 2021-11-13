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


#### Arrange
arrange(flights, year, month, day)

# Ordem decrescente
arrange(flights, desc(arr_delay))

# Exercicios pag 51

# 1 - Ordenar voos faltantes no começo

arrange(flights, !is.na(arr_time), !is.na(dep_time), !is.na(dep_delay), !is.na(arr_delay))

# 2 Vôos mais atrasados, encontrar os sairam mais cedo

arrange(flights, dep_delay)

# 4
View(flights)

#a
arrange(flights, desc(hour), desc(minute))

# b
arrange(flights, hour, minute)


#### Select
# Selecionando ano, mes e dia
select(flights, year, month, day)
# Selecionando ano até dia
select(flights, year:day)
# Selecionando tudo menos os que está entre ano e dia
select(flights, -(year:day))


#** rename
rename(flights, tail_num = tailnum)

# Selecionar algumas colunas no começo, e depois restante
select(flights, year, month, day, everything())

# Exercicios

# 2 - A coluna aparece uma vez só, mesmo declarando duas vezes
select(flights, year, year, month, day)

# 3 
?one_of
?select


# 4
select(flights, contains("TIME"))
# Poderia usar igonar case off para só vir com o texto digitado corretamente


#### Mutate
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
# Cria duas colunas Gain e Speed, no final do data
mutate(flights_sml, 
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)


# Usando propria variada criada no mutate
mutate(flights_sml,
      gain = arr_delay - dep_delay,
      hours = air_time / 60,
      gain_per_hour = gain / hours
      )

# Transmute só retorna as colunas criadas
transmute(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)


# Coisas complementares do mutate
transmute(flights, 
      dep_time, 
      hour = dep_time %/% 100,
      minute = dep_time %% 100
      )

#### Summarise
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))


by_da <- group_by(flights, year, month, day)

summarise(by_da, mean(dep_delay, na.rm = TRUE))


# Utilizando o PIPE %>%

flights %>%
  group_by(year, month, day) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE))


# Pegando voos nao cancelados
not_cancelled <- flights %>%
                  filter(!is.na(dep_delay) & !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(delay = mean(dep_delay))


delays <- not_cancelled %>%
            group_by(tailnum) %>%
            summarise(
              delay = mean(arr_delay)
            )
ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth=10)


delays <- not_cancelled %>%
            group_by(tailnum) %>%
            summarise(
              delay = mean(arr_delay, na.rm = TRUE),
              n = n()
            )

ggplot(data = delays, mapping = aes(x= n, y = delay)) +
  geom_point(alpha = 1/10)


delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x= n, y = delay)) +
  geom_point(alpha = 1/10)


# alguma funções que compõe uma melhor analise estatistica
# mean()
# median()
# sd()
# IQR()
# min()
# max()
# quantile(x, 25)
# n()
# sum(!is.na())
# n_distinct()
# sum()

