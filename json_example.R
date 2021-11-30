install.packages("rjson", repos = "https://mirrors.ustc.edu.cn/CRAN/")
library(rjson)
## from kaggle supermarket example 
mydf =read.csv("supermarket_sales - Sheet1.csv")
json = toJSON(mydf, )
cat(json, file = 'json.txt', fill = FALSE, labels = NULL, append = FALSE)
## easy example 
json_second =
  '[
  {"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"},
  {"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"}
]'
df <- fromJSON(json_second)

