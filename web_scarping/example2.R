#Biography of Van Gogh

# signatures = system.file ("CurlSSL", cainfo = "cacert.pem", package = "RCurl")
#
# url = getURL ("https://en.wikipedia.org/wiki/Vincent_van_Gogh", cainfo = signatures,
# encoding = "UTF-8")
# gogh_parsed <- htmlParse (url, encoding = "UTF-8")

url <- "https://en.wikipedia.org/wiki/Vincent_van_Gogh"

gogh_parsed <- htmlParse (rawToChar (GET (url) $ content))

# Loading hyperlinks, print the first 5
x <- getHTMLLinks (gogh_parsed) [1: 5]
x
# Loading lists (tags <ul>, <ol>), print the first 5 lines from the 10th list
readHTMLList (gogh_parsed) [[10]] [1: 5] 



### task 2 
library (stringr)
library (XML)
library (maps)
library (RCurl)
library (httr)
url_for_tabel = "https://en.wikipedia.org/wiki/List_of_works_by_Vincent_van_Gogh"
parsed= htmlParse (rawToChar (GET (url_for_tabel) $ content))

table = readHTMLTable(parsed,stringsAsFactors = FALSE)
table[[1]]
tables = rbind(table[[2]],table[[3]][-1,],table[[4]][-1,],table[[5]][-1,],table[[6]][-1,],table[[7]][-1,])
tables2 = rbind(table[[8]],table[[9]][-1,],table[[10]][-1,],table[[11]][-1,])
colnames(tables)=tables[1,]
colnames(tables2)=tables2[1,]
table_all = rbind(tables[-7][-1,],tables2[-1,])
head(table_all)
pic=getHTMLLinks (parsed)
# 
base="https://en.wikipedia.org"
for (i in pic){

  if (stringr::str_detect(i,".jpg" )){
    name = strsplit(i,split='File:')
    url_ = paste(base,i,sep="")
    gogh_parsed <- htmlParse (rawToChar (GET (url_) $ content))
    # Loading hyperlinks, print the first 5
    x <- getHTMLLinks (gogh_parsed) 
    print(x[2])
    try(
    download.file((paste("https:",x[2],sep="")),paste(name[[1]][2],".jpg",sep=""),mode="wb")
    )#print(paste(base,i,sep=""))
    }
}

