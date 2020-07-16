#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#   Add this to commit

library(shiny)
library(plotly)
library(dplyr)
library(tidyverse)
library(lubridate)

order <- read.csv('order.csv')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$plot1 <- renderPlotly({
     plot_ly(data =order,y=~Property,color = ~IsClosed,orientation='h')  %>%   
            layout(barmode='stack')
    })
    output$plot2 <- renderPlotly({
        plot_ly(data = order,y=~Assignee,color = ~IsClosed,orientation='h')  %>%   
            layout(barmode='stack')
    })
    output$plot3 <- renderPlotly({
        plot_ly(data = order,y=~Assignee,color = ~Category,orientation='h')  %>%   
            layout(barmode='stack')
    })
    output$plot4 <- renderPlotly({
        order$month <- month(order$CreateDate)
        order2 <- order %>% group_by(Property,month) %>% 
            summarise(count_property_month=n())
        plot_ly(data = order2,x=~month,y=~count_property_month,
                color = ~Property,mode='lines')
})
    output$plot5 <- renderPlotly({
        order$month <- month(order$CreateDate)
        order3 <- order %>% group_by(Category,month) %>% 
        summarise(count_category_month=n())
         plot5 <- plot_ly(data = order3,x=~month,y=~count_category_month,
                     color = ~Category,mode='lines')
})
})
