
# libs --------------------------------------------------------------------

library(rvest)
library(dplyr)
library(xml2)
library(httr)
library(jsonlite)
library(pdftools)
library(magrittr)
library(stringr)

# raspagem discursos oficiais ---------------------------------------------

u_base <- "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos"

# page <- read_html(link)

r <- httr::GET(u_base)

raspador <- function(.x, p){
        p()
        pagina_discurso <- xml2::read_html(.x)  
        discurso <- pagina_discurso %>%
                xml2::xml_find_all("//p") %>%
                xml2::xml_text() %>%
                paste(collapse = " ")
}

discursos_df <- data.frame()

for (pagina_url in seq(0,360,30)){
        
        link <- paste0('https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos?b_start:int=',
        pagina_url)
        
        pagina_especifica <- httr::GET(link)
        
        discursos_links <- pagina_especifica %>%
                xml2::read_html() %>% 
                xml2::xml_find_all("//*[@class = 'summary url']") %>% 
                xml2::xml_attr("href") %>% 
                xml2::url_absolute("https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos")
        
        nomes_discursos <- pagina_especifica %>% 
                xml2::read_html() %>% 
                xml2::xml_find_all("//*[@title = 'Document']") %>% 
                xml2::xml_text()
        
        datas_discursos <- pagina_especifica %>% 
                xml2::read_html() %>% 
                xml2::xml_find_all("//span[@class = 'summary-view-icon']") %>% 
                xml2::xml_text() %>% 
                .[seq(1,90,3)] %>% 
                str_extract_all("\\d+/\\d+/\\d+") %>% 
                lubridate::dmy()
        
        textos_discursos <- progressr::with_progress({
                p <- progressr::progressor(length(discursos_links))
                discursos <- sapply(discursos_links, raspador, USE.NAMES = FALSE, p)
        })
        
        discursos_df <- rbind(discursos_df, dplyr::data_frame(nomes_discursos,
                                                                datas_discursos,
                                                                textos_discursos)
        )
        
        print(paste("Calma q já baixamo mais de", pagina_url))
        
}


        
# testes e erros ----------------------------------------------------------

# #teste uma pagina de discurso
#
# discurso_1 <- "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/discursos/discurso-do-presidente-da-republica-jair-bolsonaro-na-cerimonia-alusiva-a-liberacao-de-trafego-na-ponte-sobre-o-rio-madeira-na-br-364-no-distrito-de-abuna-porto-velho-ro"
#
# texto_1 <- discurso_1 %>%
#         xml2::read_html() %>%
#         xml2::xml_find_all("//p") %>%
#         xml2::xml_text() %>%
        # paste(collapse = " ")






# ta dando erro
# raspar_discursos <- function(link_discurso){
#         pagina_discurso <- xml2::read_html(link_discurso)
#         discurso <- pagina_discurso %>%
#                 xml2::read_html() %>%
#                 xml2::xml_find_all("//p") %>%
#                 xml2::xml_text() %>%
#                 paste()
# }






# discursos <- sapply(discursos_links, FUN = get_discursos, USE.NAMES = F)







# assim consigo ler todos os links
# discursos_links %>% purrr::map(read_html)




#datas leticia

# datas_discursos <- datas_discursos[datas_discursos !="\n                        \n                        Página\n                    " & datas_discursos %like% "/"]
#         
# datas_discursos <- substr(datas_discursos, 51, 60)   
# 
# datas_discursos <- as.Date(datas_discursos)
# 
# datas_discursos <- as.Date(datas_discursos, tryFormats = "%d/%m/%Y")
# 
# datas_discursos <- format(datas_discursos, "%d/%m/%Y")
# 




