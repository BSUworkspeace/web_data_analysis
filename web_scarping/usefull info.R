#There is a convenient site for testing client request http://httpbin.org

#Testing the UserAgent header - information about the client object
cat(getURL("http://httpbin.org/headers",
           useragent = str_c(R.version$platform,
                             R.version$version.string,
                             sep=", ")))

#Testing the Referer header - information about the previous page
cat(getURL("http://httpbin.org/headers", referer = "http://www.rdatacollection.com/"))
#Testing the From header
cat(getURL("http://httpbin.org/headers", httpheader = c(From =
                                                            "eddie@r-collection.com")))
# Testing the Cookie header
cat(getURL("http://httpbin.org/headers", cookie = "id=12345;domain=httpbin.org"))

#GetForm function, passing parameters 
url <- "http://www.r-datacollection.com/materials/http/GETexample.php"
cat(getForm(url, name = "Eddie", age = 32))


#PostForm function, passing parameters 
url <- "http://www.r-datacollection.com/materials/http/POSTexample.php"
cat(postForm(url, name = "Eddie", age = 32, style = "post"))

