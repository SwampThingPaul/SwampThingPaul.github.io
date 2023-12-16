
#https://www.r-bloggers.com/awesome-twitter-word-clouds-in-r/
library(AnalystHelper)

library(rtweet)
library(tidytext)
library(dplyr)
library(stringr)
library(wordcloud2)

#grab tweets
dat=get_timeline("SwampThingPaul",n=6000,since="2019-01-01",until="2019-12-31")
nrow(dat)
range(dat$created_at)
attributes(dat$created_at)
dat=subset(dat,created_at<date.fun("2020-01-01","UTC"))

#no retweets
dat=subset(dat,is_retweet==F)

#Unnest the words - code via Tidy Text
dat.table=dat%>%
  unnest_tokens(word,text)
dat.table$word
#remove stop words - aka typically very common words such as "the", "of" etc
data(stop_words)
dat.table <- dat.table %>%
  anti_join(stop_words)

#do a word count
dat.table <- dat.table %>%
  count(word, sort = TRUE) 
dat.table
dat.table$num=as.numeric(dat.table$word)>0
dat.table=subset(dat.table,is.na(num)==T)

#Remove other nonsense words
dat.table <-dat.table %>%
  filter(!word %in% c('t.co', 'https','post','makes','link'))

head(dat.table)

wordcloud2(dat.table, size=0.7)

#better word cloud
cols=wesanderson::wes_palette("Zissou1",5)

aquatic="D:/_Github/SwampThingPaul.github.io/wordcloud/LA.jpg"

wordcloud2(dat.table, size=0.7,color=rep_len( cols, nrow(dat.table) ),backgroundColor = "black" )
