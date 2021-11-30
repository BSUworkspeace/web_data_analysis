# example 1
# package for regular expressions
install.packages ("stringr")
# package for loading maps
install.packages ("maps")
# main package for web scraping
install.packages ("RCurl")
# package for working with XML, HTML, Xpath
install.packages ("XML") 

install.packages(c("rvest",
                 "selectr",
                 "xml2",
                 "jsonlite",
                 "tidyverse"))


library(lpSolve)
c<-c(5,2,4,3)
cost<-matrix(c,nrow=2,byrow=T)
capacity<-c(20,15)
demand<-c(20,15)
trans.sol<-lp.transport(cost,"min",rep("<=",2),capacity,rep("=",2),demand)
