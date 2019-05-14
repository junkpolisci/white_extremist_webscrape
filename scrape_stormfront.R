library(rvest)



tictoc::tic("readhtml")
nwow_pages_url <- c("https://www.stormfront.org/forum/t631153/")
for (i in 2:740){
  nwow_pages_url <- c(nwow_pages_url, paste0("https://www.stormfront.org/forum/t631153-", i, "/"))
} #generate the links to each of the pages of the list 
text <- data.frame(text = as.character())
users <- data.frame(users = as.character())
time <- data.frame(time = as.character())

pattern_time <- ("\\d{2}\\-\\d{2}\\-\\d{4}\\,\\s\\d{2}\\:\\d{2}\\s[A-Z]+") #pattern for date/time extraction
pattern_name <- ("^+(\\s*|\\_*)[A-Za-z]+(\\s*|\\_*)[A-Za-z]+(\\s*|\\_*)[A-Za-z]+(\\s*|\\_*)[A-Za-z]+(\\s*|\\_*)[A-Za-z]+(\\s*|\\_*)[A-Za-z]+(\\s*|\\_*)[A-Za-z]+") #pattern for username extraction

for(i in 1:length(nwow_pages_url)){
  #this is the part that reads the htmls, extracts the text, username, and date/time of the postes 
  nwow_page_html <- read_html(nwow_pages_url[i]) #read the html
  
  nwow_pages_nodes <- html_nodes(nwow_page_html, "#posts .alt1 div:nth-child(3)") #extract the nodes that are the text posts 
  nwow_pages_text <- html_text(nwow_pages_nodes) #extract the text from those posts
  text_temp <- data.frame(nwow_pages_text) #put the text in a temporary dataframe to add to the total dataframe
  colnames(text_temp) <- colnames(text) #name the columns so that I can use rbind
  text <- rbind(text, text_temp) #add it to the dataframe with all posts 
  
  #this extracts the date/time of the post
  nwow_pages_nodes <- html_nodes(nwow_page_html, "#posts .thead:nth-child(1)") #extract the user/time nodes
  nwow_pages_users_time <- html_text(nwow_pages_nodes)
  
  #this extracts the date from above
  nwow_pages_time <- stringr::str_extract_all(nwow_pages_users_time, pattern_time) #use the pattern defined above to extract the date/time from the posts
  time_temp <- nwow_pages_time[seq(1, length(nwow_pages_time), 2)] #pull the data/time. The vector has names and date/time sequenced, so i need to select every other element
  time_temp <- data.frame(unlist(time_temp)) #unlist so that I have nrows = numbers of posts 
  colnames(time_temp) <- colnames(time) #name column so that it can be bound to permanent dataframe
  time <- rbind(time, time_temp) #bind to permanent time dataframe
  
  #this extracts the user from above 

  nwow_pages_users <- stringr::str_extract_all(nwow_pages_users_time, pattern_name) #extract usernames
  users_temp <- nwow_pages_users[seq(2, length(nwow_pages_users), 2)] #put usernames into a vector 
  users_temp <- data.frame(unlist(users_temp)) #reshape that vector so that nrows = number of posts
  colnames(users_temp) <- colnames(users) #name column so that it can be bound to permanent dataframe
  users <- rbind(users, users_temp) #bind to permanent dataframe
}
tictoc::toc()
#beepr::beep(8)
 
^\\n\\nQuote\:.*\\n\\n