library(tidytext) #get_sentiments
library(tidyverse)
library(textdata)
library(ggpubr)
library(wordcloud2)

#Women
#Reading the women's CSV file
Women <- read.csv(file ='D:\\Users\\User\\Desktop\\Analytics Engineering\\GA\\womenshoes_cleanedfinal.csv')

#Viewing the observations of the CSV file
#view(Women)

#Restructuring Women_review as one-token-per-row format
Women_review <- Women %>% #Pipe data frame 
                select(reviews)%>% #Select variables of interest
                unnest_tokens(word, reviews) #Split column in one token per row format

#Viewing the observations of women_review
#view(Women_review)

#Creating and adding user-defined stop words
my_stop_words <- tibble( #Construct a dataframe
                        word = c(
                          "https","http","00z","dateSeen","dateAdded","rating","date","sourceURLs","Seen",
                          "Added","username","T","Z","title","dp","02t03","11t00","01t00","13t00","15t00",
                          "14t19","14t18","pdp","10t00","30t04","20t00","text","14t00","28t00","02t00",
                          "09t00","25t00","18t00","19t18","52z","34z","12z","27t01","01t02","16t00","23t00",
                          "12t00","22t00","24t00","07t00","32z","07t00","08t00","03t00","17z","16z","18z",
                          "01z","36z","09z","29z","15z","24z","19t00","46z","ugg","30t00","06t00",
                          "29t00","12t05","58z","48z","11t08","10z","21t00"),
                        lexicon = "shoe"
                        )

#view(my_stop_words)

#Connecting the data frames of user defined and library extracted stop words
all_stop_words <- stop_words %>% bind_rows(my_stop_words)

#Viewing the connected data frame
#view(all_stop_words)

#Removing the numbers in women_review
no_numbers <- Women_review %>% filter(is.na(as.numeric(word))) #Filter() returns rows where conditions are true

#view(no_numbers)

#Removing the stop words from the data frame
no_stop_words <- no_numbers %>% anti_join(all_stop_words, by = "word")

#Downloading NRC Emotion Lexicon.zip to obtain specific sentiment lexicons in a tidy format
nrc <- get_sentiments("nrc") 

#view(nrc)

#Joining the filtered data frame with sentiment lexicons
nrc_words <- no_stop_words %>% inner_join(nrc, by="word")

#Viewing the results
#view(nrc_words)

#Constructing the pie chart for sentiment analysis
pie_words <- nrc_words %>%
              group_by(sentiment) %>% #Group by sentiment type       
              tally %>% #Counts number of rows
              arrange(desc(n)) #Arrange sentiments in descending order based on frequency

#Calculating percentage for each sentiment
pie_labels <- paste0(round(100 * pie_words$n/sum(pie_words$n), 2), "%")

#Constructing the pie chart for sentiment analysis
ggpubr::ggpie(pie_words, "n", label=pie_labels, fill="sentiment", color="white", palette="rickandmorty",
              border.width = 1.5, offset=.7, title="Sentiment Analysis for Women's Shoes Review")

#Calculating the frequency of occurrences of the keyword
words_count <- no_stop_words %>% dplyr::count(word, sort = TRUE)

#Building the wordcloud 
wordcloud <- wordcloud2(data = words_count, minRotation = 0, maxRotation = 0, ellipticity = 0.6, size = 2.5)

#Displaying the wordcloud
wordcloud

#Men
#Reading the men's CSV file
men <- read.csv(file ='D:\\Users\\User\\Desktop\\Analytics Engineering\\GA\\menshoes_final.csv')

#Viewing the observations of the CSV file
view(men)

#Restructuring men_review as one-token-per-row format
men_review <- men %>% #Pipe data frame 
  select(reviews)%>% #Select variables of interest
  unnest_tokens(word, reviews) #Split column in one token per row format

#Viewing the observations of men_review
view(men_review)

#Creating and adding user-defined stop words
my_stop_words <- tibble( #Construct a dataframe
  word = c(
    "https","http","00z","dateSeen","dateAdded","rating","date","sourceURLs","Seen",
    "Added","username","T","Z","title","dp","02t03","11t00","01t00","13t00","15t00",
    "14t19","14t18","pdp","10t00","30t04","20t00","text","14t00","28t00","02t00",
    "09t00","25t00","18t00","19t18","52z","34z","12z","27t01","01t02","16t00","23t00",
    "12t00","22t00","24t00","07t00","32z","07t00","08t00","03t00","17z","16z","18z",
    "01z","36z","09z","29z","43z","13z","37z","58z","26z","24z","28z","33z","17t00",
    "21t00","11t23","19t00","06t00","29t00","30t00","04t00","40z","11z","15z","14z"),
  lexicon = "shoe"
)

view(my_stop_words)

#Connecting the data frames of user defined and library extracted stop words
all_stop_words <- stop_words %>% bind_rows(my_stop_words)

#Viewing the connected data frame
view(all_stop_words)

#Removing the numbers in men_review
no_numbers <- men_review %>% filter(is.na(as.numeric(word))) #Filter() returns rows where conditions are true

view(no_numbers)

#Removing the stop words from the data frame
no_stop_words <- no_numbers %>% anti_join(all_stop_words, by = "word")

#Downloading NRC Emotion Lexicon.zip to obtain specific sentiment lexicons in a tidy format
nrc <- get_sentiments("nrc") 

view(nrc)

#Joining the filtered data frame with sentiment lexicons
nrc_words <- no_stop_words %>% inner_join(nrc, by="word")

#Viewing the results
view(nrc_words)

#Constructing the pie chart for sentiment analysis
pie_words <- nrc_words %>%
  group_by(sentiment) %>% #Group by sentiment type       
  tally %>% #Counts number of rows
  arrange(desc(n)) #Arrange sentiments in descending order based on frequency

#Calculating percentage for each sentiment
pie_labels <- paste0(round(100 * pie_words$n/sum(pie_words$n), 2), "%")

#Constructing the pie chart for sentiment analysis
ggpubr::ggpie(pie_words, "n", label=pie_labels, fill="sentiment", color="white", palette="rickandmorty",
              border.width = 1.5, offset=.7, title="Sentiment Analysis for Men's Shoes Review")

#Calculating the frequency of occurrences of the keyword
words_count <- no_stop_words %>% dplyr::count(word, sort = TRUE)

#Building the wordcloud 
wordcloud <- wordcloud2(data = words_count, minRotation = 0, maxRotation = 0, ellipticity = 0.6, size = 2.5)

#Displaying the wordcloud
wordcloud