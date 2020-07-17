#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(plotly)
library(shinythemes)
library(tidyverse)
library(lubridate)
library(dplyr)


# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        dashboardHeader(title = 'Amifor Dashboard'),
        dashboardSidebar(
            sidebarMenu(
                menuItem('Property',tabName = 'Property'),
                menuItem('Assignee',tabName = 'Assignee'),
                menuItem('Category',tabName = 'Category'),
                menuItem('Vendor',tabName = 'Vendor')
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(tabName = 'Property',
                        fluidRow(
                            box(title='Open/Closed work orders',
                                width = 12,
                                plotlyOutput('plot1'))
                        ),
                        fluidRow(
                            box(title = 'Monthly work orders',
                                width = 12,
                                plotlyOutput('plot4'))
                        ),
                        fluidRow(
                            box(title = 'Late open orders',
                                width = 12,
                                plotlyOutput('plot6'))
                        ),
                        fluidRow(
                            box(title = 'Duration from CreatDate to CloseDate',
                                width = 12,
                                plotlyOutput('plot7'))
                        ),
                        fluidRow(
                            box(title = 'Vendors',
                                width = 12,
                                plotlyOutput('plot8'))
                        )
                ),
                tabItem(tabName = 'Assignee',
                        fluidRow(
                            box(title = 'Open/Closed work orders',
                                width = 12,
                                plotlyOutput('plot2'))
                        ),
                        fluidRow(
                            box(title = 'Category for assignee',
                                width = 12,
                                plotlyOutput('plot3'))
                        )
                ),
                tabItem(tabName = 'Category',
                        fluidRow(
                            box(title = 'Monthly work order by Category',
                                width = 12,
                                plotlyOutput('plot5'))
                        )
                    
                ),
                tabItem(tabName = 'Vendor',
                        fluidRow(
                            box(title = 'Monthly orders',
                                width = 12,
                                plotlyOutput('plot9'))
                        ))
            )
            
        )
    )
)



order <- read.csv('order.csv')
order$month <- month(order$CreateDate)
order$duration <- order$duration+1

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
        order2 <- order %>% group_by(Property,month) %>% 
            summarise(count_property_month=n())
        plot_ly(data = order2,x=~month,y=~count_property_month,
                color = ~Property,mode='lines')
    })
    output$plot5 <- renderPlotly({
        
        order3 <- order %>% group_by(Category,month) %>% 
            summarise(count_category_month=n())
        plot5 <- plot_ly(data = order3,x=~month,y=~count_category_month,
                         color = ~Category,mode='lines')
    })
    output$plot6 <- renderPlotly({
        order4 <- order %>% filter(IsClosed == 'FALSE') %>% 
            filter(DueDate < Sys.Date()) %>% group_by(month) %>% summarise(count_order=n())
        plot6 <- plot_ly(data = order4,x=~month,y=~count_order,mode='lines') %>% 
            layout(xaxis=list(title='month'),yaxis=list(title='open late orders'))
    })
    output$plot7 <- renderPlotly({
        order5 <- order %>% group_by(Property) 
        plot7 <- plot_ly(data = order5,x=~Property,y=~duration,type = 'box')
    })
    output$plot8 <- renderPlotly({
        plot_ly(data =order,x=~Property,color = ~Vendor)  %>% layout(barmode='stack')
    })
    output$plot9 <- renderPlotly({
        order6 <- order %>% group_by(Vendor,month) %>% summarise(count_order=n())
        plot9 <- plot_ly(data = order6, x= ~month, y=~count_order,color=~Vendor,mode='lines')
    })
})




