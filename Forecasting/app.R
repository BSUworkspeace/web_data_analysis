#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(fpp2)
library(tseries)
library(dplyr)
library(tidyr)
library(purrr)
library(reshape2)


## read csv
data_clean <- function(x){
    x %>%
        select(-Province.State, -Lat, -Long) %>% 
        gather(key="date", value="Value", -Country.Region) %>% 
        group_by(Country.Region, date) %>% 
        summarise("Value"=sum(Value)) %>% 
        ungroup() %>% 
        select(date, "country"=Country.Region, Value) %>% 
        mutate(date, date=as.Date(substring(date, 2, nchar(date)),"%m.%d.%y"))%>% 
        arrange(date)
}
read_data <- function(){
    confirmed <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
    deaths <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
    recovered <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")
    data <- list(confirmed, deaths, recovered) %>% 
        lapply(data_clean) %>% 
        reduce(left_join,by = c("date", "country"))
    colnames(data)[3:5] <- c("confirmed", "deaths", "recovered")
    return(data)  
}


ui <- fluidPage(
    title = "COVID-19 Forecatsing",
    sidebarLayout(
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "County Statistics",
                    plotlyOutput("allCountries"),
                    hr(),), 
                tabPanel(
                    "Forecasting",
                    plotOutput("forecasting", click = "plot_click"),
                    hr(),
                    ),
                tabPanel("Table For Case Data",
                         DT::DTOutput("tabular")))), 
    
        sidebarPanel(
            selectInput("countrySelector",
                    label="Select a Country",
                    choices=c("Singapore", "Japan", "Indonesia", "US", "Malaysia", "China"),
                    selected="Singapore"),
        dateRangeInput("dateSelector",
                       label = "Observation Period",
                       start = as.Date("2020-01-01"),
                       end = Sys.Date(),
                       min = as.Date("2019-12-01"),
                       max = Sys.Date(),
                       separator = "to"
        ),
        checkboxInput("smoothSelector",
                      label = "Smoother?", value=FALSE),
        style="background:black;color:white;"
    )

    )

)
tolong <- function(data){
    data %>% melt(
        id.vars=c("date", "country"),
        measured.vars=c("confirmed", "recovered", "dead"))
}
corona <- read_data()
long <- tolong(corona)
server <- function(input, output){
    
    dat <- reactive({
        x <- subset(long, 
                    (country == input$countrySelector& date >= input$dateSelector[1]& date < input$dateSelector[2]))
        return(x)
    })
    
    
    output$allCountries <- renderPlotly({
        geoms <- switch(as.character(input$smoothSelector), 
                        "TRUE"=geom_smooth(size=1.2), 
                        "FALSE"=geom_line(size=1.2))
        ggplotly(
            ggplot(data=dat(), 
                   aes(x=date, y=value, col=variable)) +
                geoms +
                labs(title = input$titleInput) 
                
        )
    })
    
    
    
    output$tabular <- DT::renderDT({
        x <- corona[corona$country == input$countrySelector,]
        return(x)
    })
    

    
    output$forecasting <- renderPlot({
        df = corona[corona$country == input$countrySelector,]
        confirmed.ts = ts(df[,'confirmed'],start = (c(2020,1,22)),frequency = 365)
        recovered.ts = ts(df[,'recovered'],start = (c(2020,1,22)),frequency = 365)
        deaths.ts = ts(df[,'deaths'],start = (c(2020,1,22)),frequency = 365)
        TBATS_confirmed = forecast(tbats(confirmed.ts), h=365)
        TBATS_recovered = forecast(tbats(recovered.ts), h=365)
        TBATS_deaths = forecast(tbats(recovered.ts), h=365)
        autoplot(confirmed.ts,series="confirmed")+
                autolayer(recovered.ts,series="recovered")+
                autolayer(deaths.ts,series="deaths")+
                autolayer(TBATS_recovered,series="recovered")+
                autolayer(TBATS_confirmed,series="confirmed")+
                autolayer(TBATS_deaths,series="deaths")+
                xlab("year") + ylab("case number") +
                ggtitle("covid-19 Time Series Forecasting")+
                theme(text = element_text(family = "STHeiti"))
                
        
    })
    
}
# Run the application 
shinyApp(ui = ui, server = server)
