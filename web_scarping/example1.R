# Example 1 - List of World Heritage in Danger -
# List of World Heritage Sites in Danger

library (stringr)
library (XML)
library (maps)
library (RCurl)
library (httr)

## Old version
# # create an object to work over the SSL protocol
# signatures = system.file ("CurlSSL",
# cainfo = "cacert.pem",
# package = "RCurl")

## loading the page
# url = getURL ("https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger",
# cainfo = signatures, encoding = "UTF-8")
# create html object
# heritage_parsed <-htmlParse (url, encoding = "UTF-8")

url <- "https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger"
heritage_parsed <- htmlParse (rawToChar (GET (url) $ content))



# read all tables from it
tables <- readHTMLTable (heritage_parsed, stringsAsFactors = FALSE)

# the table we need with number 2
danger_table <- tables [[2]]
# print the table (several lines are given)
danger_table

danger_table <- danger_table [-1,]
some_table <- tables [[4]]
some_table

# table column names
names (danger_table)
names (some_table)

# we only need some columns
danger_table <- danger_table [, c (1, 3, 4, 6, 7)]

# rename
colnames (danger_table) <- c ("name", "locn", "crit", "yins", "yend")
# print the first 3 names
danger_table $ name [1: 3]
# set our values for the object type
danger_table $ crit <- ifelse (str_detect (danger_table $ crit, "Natural") == TRUE, "nat", "cult")
# years are converted to numbers
danger_table $ yins <- as.numeric (danger_table $ yins)
# from the column "year of inclusion in the list" take only the last values
# (the object could have been in the list several times)
#yend_clean <- unlist (str_extract_all (danger_table $ yend, "[[: digit:]] {4} - $"))
yend_clean <- unlist (str_extract_all (danger_table $ yend, "[[: digit:]]{4}–$"))
yend_clean
# years are converted to numbers
yend_clean <- unlist (str_replace_all (yend_clean, "–", ""))
yend_clean
danger_table $ yend <- as.numeric (yend_clean)
danger_table $ yend

# print coordinates from 3 lines
danger_table $ locn [c (1, 3, 5)]

# using regular expressions to select coordinates in decimal format
reg_y <- "[/]*[-]*[[: digit:]]*[.]*[[: digit:]]*[;]"
reg_x <- "; [-]*[[: digit:]]*[.]*[[: digit:]]*"
y_coords <- str_extract (danger_table $ locn, reg_y)
y_coords <- as.numeric (str_sub(y_coords,0,-2))
danger_table $ y_coords <- y_coords
x_coords <- str_extract (danger_table $ locn, reg_x)
x_coords <- as.numeric (str_sub(x_coords,3,-1))
danger_table $ x_coords <- x_coords
#danger_table $ locn <- NULL

danger_table $ x_coords

# round off
round (danger_table $ y_coords, 2) [1: 3]
round (danger_table $ x_coords, 2) [1: 3]

# so we have a table with 47 rows and 6 columns
dim (danger_table)
# containing such data
head (danger_table)

# we want to draw objects on the world map
# set the vector for icons (natural - circle, cultural - triangle)
pch <- ifelse (danger_table $ crit == "nat", 19, 2)

# set a vector for color (natural - green, cultural - blue)
col <- ifelse (danger_table $ crit == "nat", "green", "blue")

# print the world map
maps :: map ("world", col = "darkgrey", lwd = 0.5, mar = c (0.1, 0.1, 0.1, 0.1))
# and output objects to it
points (danger_table $ x_coords, danger_table $ y_coords, pch = pch, col = col)
# frame everything
box ()
par (mfrow = c (2,1))
# Now let's create a histogram, according to the years of inclusion of objects in the list
hist (danger_table$yend, freq = TRUE, xlab = "Year when site was put on the list of endangered sites", main = "")
# And a histogram by the waiting times for including objects in the list
duration <- danger_table$yend - danger_table$yins


hist (duration, freq = TRUE, xlab = "Years it took to become an endangered site", main = "") 
