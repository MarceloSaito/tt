
# libs --------------------------------------------------------------------

library(rtweet) # for harvesting tweets
library(tm) # for text mining
library(dplyr) 
library(tidyr)
library(data.table)
library(ggplot2)
library(ggthemes)
#library(e1071) # has the naiveBayes algorithm
#library(caret) # good ML package, I like the confusionMatrix() function
library(here)
library(stringr)
library(fpc)
library(topicmodels)
library(cluster)
library(tm)
library(NLP)

local <- getwd()

setwd(local)

# unzip -------------------------------------------------------------------

unzip("rHD-Vignette-Text-Mining-master.zip")

# dados do twitter --------------------------------------------------------

api_key <- "tqQjvas6gJ8bhsjQZETRd36w2"

api_secret_key <- "K0a0b5oCZbYnJ432PPPU3EkJf9jWHRSz2f4rgJbwNe9aHQiZt1"

# bearer_token <- "AAAAAAAAAAAAAAAAAAAAABXgOwEAAAAAj4ofyDvwpkXJJNqC99Gfm0HEv1w%3DF0zfmegHmVl1cmSTumhhwcyyPlFdwrbzgGGb9PHOxGYqMIyHMM"

vacinacao <- "vacinacao_twitter_app"

access_token <- "1386668086904958978-dKDNBBP45R1IWAWRYgXz5cRXxBtq1S"

access_secret <- "SZ9oTI8WQHT4qbvVKIAKHpkSklOHivOerjSgxni8JTYYs"


# create_token ----------------------------------------------------------------

token <- create_token(app = vacinacao, 
                      consumer_key = api_key, 
                      consumer_secret = api_secret_key,
                      access_token = access_token,
                      access_secret = access_secret)
token


# scraping ----------------------------------------------------------------

bolsonaro <- get_timeline(user = "jairbolsonaro", n = 3200)

min_saude <- get_timeline(user = "minsaude", n = 5000)



# analise bolsonaro -----------------------------------------------------------------

bolsonaro_tt <- read.csv(file = "jairbolsonaro_08_12_2020.csv", header = TRUE, sep = "\t", encoding = "UTF-8")

bolsonaro_tt <- bolsonaro_tt %>% 
        select(date, tweet)

# analise ministerio da saude ---------------------------------------------

min_saude_tt <- read.csv(file = "min_saude_08_12_2020.csv", header = TRUE, sep = "\t", encoding = "UTF-8")

min_saude_tt <- min_saude_tt %>% 
        select(date, tweet)


