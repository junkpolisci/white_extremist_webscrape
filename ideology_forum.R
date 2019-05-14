# https://www.stormfront.org/forum/f61/
# https://www.stormfront.org/forum/f217/
# https://www.stormfront.org/forum/f87/
# https://www.stormfront.org/forum/f219/
# 
#   
# https://www.stormfront.org/forum/f239/
#   https://www.stormfront.org/forum/t1208531/
#   https://www.stormfront.org/forum/t1197557/
#   https://www.stormfront.org/forum/t1194717/
  
  
library(rvest)
library(tidyverse)

#generate a url for each page of the ideology and philosophy forum 
ideo_philo_urls <- c("https://www.stormfront.org/forum/t451603/")

#generate a url for each forum 
for(i in 2:502){
  ideo_philo_urls <- c(ideo_philo_urls, paste0("https://www.stormfront.org/forum/t451603-", 
                                               i,
                                               "/"))
}

ideology_forum <- data.frame(user = c(),
                             date = c(),
                             time = c(),
                             text = c())

for(i in 1:length(ideo_philo_urls)){
  page <- read_html(url(ideo_philo_urls[i]))
  
  page_text_prelim <- page %>% 
    html_nodes("#posts .alt1") %>% 
    html_text()
    
  page_text <- page_text_prelim[seq(1, 20, 2)]
  
  page_date_time <- page %>% 
    html_nodes("#posts .thead:nth-child(1)") %>% 
    html_text() 
  
  page_date_time_prelim <- page_date_time %>% 
                           data.frame() %>% 
                           janitor::clean_names() %>% 
                           mutate(date = stringr::str_extract(x, 
                                                              "\\d{2}\\-\\d{2}\\-\\d{4}"),
                                  time = stringr::str_extract(x, 
                                                              "\\d{2}\\:\\d{2}\\s[A-Z]{2}")) %>% 
                           filter(!is.na(date)) %>%  
                           select(date,
                                  time)
  
  page_date <- as.vector(page_date_time_prelim$date)
  page_time <- as.vector(page_date_time_prelim$time)
  
  page_user_prelim <- page %>% 
                      html_nodes("#posts .alt2") %>% 
                      html_text() %>% 
                      data.frame() %>% 
                      janitor::clean_names() %>% 
                      mutate(text = as.character(x),
                             user_time_detect = as.numeric(stringr::str_detect(text,
                                                             "Posts:")),
                             user = stringr::str_extract(text,
                                       "([A-z0-9]+.)+")) %>% 
                      filter(user_time_detect == 1) %>% 
                      select(user)
  
  page_user <- as.vector(page_user_prelim$user)
  
  #as of 5/6/2019 this errors on the final loop because the last page only has 7 posts and the page_date and page_time
  #vectors are length 7, but text is 10 with the last 3 NA 
  
  
  page_df <- data.frame(user = as.character(page_user),
                        date = as.character(page_date),
                        time = as.character(page_time), 
                        text = as.character(page_text))

  
  ideology_forum <- rbind(ideology_forum, page_df)
}
##########################################################################################################
#This deals with that last loop that failed 

page_text <- as.vector(na.omit(page_text))
page_df <- data.frame(user = as.character(page_user),
                      date = as.character(page_date),
                      time = as.character(page_time), 
                      text = as.character(page_text))


ideology_forum <- rbind(ideology_forum, page_df)
ideology_forum <- ideology_forum %>% 
                  mutate(id = seq_along(user)) #ID the comments so they match with the comment number on the website

ideology_forum_removed <- ideology_forum[-c(3294, 3481, 3552, 4102, 4308, 4434, 4908, 5015),]
 
 cleaning <- ideology_forum_removed %>% 
             mutate(text_nore = stringr::str_replace_all(text, 
                                                         "Re: National Socialism",
                                                         ""),
                    text_noquote = stringr::str_replace_all(text_nore, 
                                                            "Quote.(\\n)*.*(\\n)*((.*)|(\\n*))*\\n{2}",
                                                            ""),
                    text_nobreak = stringr::str_replace_all(text_noquote,
                                                            "\\c*",
                                                            ""), 
                    text_nopunct = stringr::str_replace_all(text_nobreak,
                                                            "[[:punct:]]*",
                                                            ""))
##########################################################################################################
#Analysis setup 

