# Voz'mem dannyye za 2016 god: url <- "http://www.elections.state.md.us/elections/2016/election_data/index.html" # Izvlechem vse giperssylki: links <- try(getHTMLLinks(htmlParse(rawToChar(GET(url)$content)))) #links <- getHTMLLinks(url) # Vyberem giperssylki, kotoryye zakanchivayutsya na _General.csv: filenames <- links[str_detect(links, "_General.csv")] filenames_list <- as.list(filenames) filenames_list[1:3] # Funktsiya dlya zagruzki dokumenta po giperssylke: downloadCSV <- function(filename, baseurl, folder) { dir.create(folder, showWarnings = FALSE) fileurl <- str_c(baseurl, filename) if (!file.exists(str_c(folder, "/", filename))) { download.file(fileurl, destfile = str_c(folder, "/", filename)) Sys.sleep(1) } } # Perebirayem spisok giperssylok i zagruzhayem dokumenty: for ( i in 1:length(filenames_list)) { downloadCSV(filenames_list[[i]], baseurl = "http://www.elections.state.md.us/elections/2016/election_data/", folder = "elec16_maryland") }
#Ещё
1023 / 5000
#Результаты перевода
# Let's take the data for 2016:
url <- "http://www.elections.state.md.us/elections/2016/election_data/index.html"
# Extract all hyperlinks:
links <- try (getHTMLLinks (htmlParse (rawToChar (GET (url) $ content))))
#links <- getHTMLLinks (url)

# Select hyperlinks that end with _General.csv:
filenames <- links [str_detect (links, "_General.csv")]
filenames_list <- as.list (filenames)
filenames_list [1: 3]

# Function for loading a document by hyperlink:
downloadCSV <- function (filename, baseurl, folder) {
  dir.create (folder, showWarnings = FALSE)
  fileurl <- str_c (baseurl, filename)
  if (! file.exists (str_c (folder, "/", filename))) {
    download.file (fileurl,
                   destfile = str_c (folder, "/", filename))
    Sys.sleep (1)
  }
}

# Loop through the list of hyperlinks and load the documents:
for (i in 1: length (filenames_list))
{
  downloadCSV (filenames_list [[i]],
               baseurl = "http://www.elections.state.md.us/elections/2016/election_data/",
               folder = "elec16_maryland")
  
} 



#### task3.2 -Hillary Clinton vs  Donald J. Trump
tdf = read.csv("elec16_maryland/All_By_Precinct_2016_General.csv")
head(tdf)
library("ggplot2")
library(dplyr)
library(ggfortify)
data1 = tdf[tdf$Candidate.Name=="Hillary Clinton",] %>% 
  
  summarise(Election.Night.Votes = sum(Election.Night.Votes))%>%
  mutate(Candidate.Name = "Hillary Clinton")
# %>%
#   ggplot(aes(x=Election.District, y=Election.Night.Votes)) +
#   geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4)



ggplot(data,aes(Election.District,Election.Night.Votes))+geom_bar()
data2 = tdf[tdf$Candidate.Name=="Donald J. Trump",] %>% 
  group_by(Election.District)%>%
  summarise(Election.Night.Votes = sum(Election.Night.Votes))%>%
  mutate(Candidate.Name = "Donald J. Trump")
data2
# %>%
#   ggplot(aes(x=Election.District, y=Election.Night.Votes)) +
#     geom_bar(stat="identity")
ggplot()+
  geom_bar(stat="identity",data=data1,aes(x=1, y=Election.Night.Votes),fill="#f68060",show.legend = T)+
  geom_bar(stat="identity",data=data2,aes(x=2, y=Election.Night.Votes))

#### 3.3 
tdf[tdf$Candidate.Name=="Donald J. Trump",] %>% 
  group_by(Election.District)%>%
  summarise(Election.Night.Votes = sum(Election.Night.Votes))%>%
  mutate(Candidate.Name = "Donald J. Trump")%>%
  ggplot()+
  geom_bar(stat="identity",aes(x=Election.District, y=Election.Night.Votes),fill="#f68060",show.legend = T)
# the election district list 
#00 State Level
#01 Allegany County
#02 Anne Arundel County
#03 Baltimore City
#04 Baltimore County
#05 Calvert County
#06 Caroline County
#07 Carroll County
#08 Cecil County
#09 Charles County
#10 Dorchester County
#11 Frederick County
#12 Garrett County
#13 Harford County
#14 Howard County
#15 Kent County
#16 Montgomery County
#17 Prince George's County
#18 Queen Anne's County
#19 St. Mary's County
#20 Somerset County
#21 Talbot County
#22 Washington County
#23 Wicomico County
#24 Worcester County


