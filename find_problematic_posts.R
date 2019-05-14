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
text <- text[-c(3294, 3481, 3552, 4102, 4308, 4434, 4908, 5015)]

text_nore <-  stringr::str_replace_all(text, 
                                     "Re: National Socialism",
                                     "")
text_noquote <- c()

for(i in 1:5009){
text_noquote[i] <- str_replace_all(text_nore[i], 
                                "Quote.(\\n)*.*(\\n)*((.*)|(\\n*))*\\n{2}",
                                "")
}
