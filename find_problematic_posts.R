library(rvest)
library(tidyverse)
library(stringr)


all <- load("white_nationalist_ideology")

# cleaning <- ideology_forum %>% 
#             mutate(text_nore = stringr::str_replace_all(text, 
#                                                         "Re: National Socialism",
#                                                         ""),
#                    text_noquote = stringr::str_replace_all(text_nore, 
#                                                            "Quote.(\\n)*.*(\\n)*((.*)|(\\n*))*\\n{2}",
#                                                            ""),
#                    text_nobreak = stringr::str_replace_all(text_noquote,
#                                                            "\\c*",
#                                                            ""), 
#                    text_nopunct = stringr::str_replace_all(text_nobreak,
#                                                            "[[:punct:]]*",
#                                                            ""))

text <- as.vector(cleaning$text)

text_nore <-  stringr::str_replace_all(text, 
                                     "Re: National Socialism",
                                     "")

text_noquote <- str_replace_all(text_nore, 
                                "Quote.(\\n)*.*(\\n)*((.*)|(\\n*))*\\n{2}",
                                "")