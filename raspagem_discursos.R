
# libs --------------------------------------------------------------------

library(rvest)
library(dplyr)
library(xml2)
library(httr)
library(jsonlite)
library(pdftools)
library(magrittr)

# raspagem discursos oficiais ---------------------------------------------

u_base <- "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos"

# page <- read_html(link)

r <- httr::GET(u_base)

discursos_links <- r %>%
        xml2::read_html() %>% 
        xml2::xml_find_all("//*[@class = 'summary url']") %>% 
        xml2::xml_attr("href") %>% 
        xml2::url_absolute("https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos")

raspador <- function(.x, p){
        p()
        pagina_discurso <- xml2::read_html(.x)  #acho q aqui é o problema
        discurso <- pagina_discurso %>%
                xml2::xml_find_all("//p") %>%
                xml2::xml_text() %>%
                paste(collapse = " ")
}

discursos_1_pag <- progressr::with_progress({
        p <- progressr::progressor(length(discursos_links))
        discursos <- sapply(discursos_links, raspador, USE.NAMES = FALSE, p)
})

nomes_discursos <- r %>% 
        xml2::read_html() %>% 
        xml2::xml_find_all("//*[@title = 'Document']") %>% 
        xml2::xml_text()

datas_discursos <- r %>% 
        xml2::read_html() %>% 
        xml2::xml_find_all("//i[@class = 'icon-day']") %>% 
        xml2::xml_text()
        
        
        
        
discursos_df <- data.table::data.table(nomes_discursos, discursos_1_pag)



        
# testes e erros ----------------------------------------------------------

# #teste uma pagina de discurso
# 
# discurso_1 <- "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos/discurso-do-presidente-da-republica-jair-bolsonaro-na-cerimonia-alusiva-a-liberacao-de-trafego-na-ponte-sobre-o-rio-madeira-na-br-364-no-distrito-de-abuna-porto-velho-ro"
# 
# texto_1 <- discurso_1 %>%
#         xml2::read_html() %>%
#         xml2::xml_find_all("//p") %>%
#         xml2::xml_text() %>%
#         paste(collapse = " ")

## ta dando erro 
# raspar_discursos <- function(link_discurso){
#         pagina_discurso <- xml2::read_html(link_discurso)
#         discurso <- pagina_discurso %>% 
#                 xml2::read_html() %>% 
#                 xml2::xml_find_all("//p") %>% 
#                 xml2::xml_text() %>% 
#                 paste()    
# }

# discursos <- sapply(discursos_links, FUN = get_discursos, USE.NAMES = F)

## assim consigo ler todos os links
# discursos_links %>% purrr::map(read_html)



