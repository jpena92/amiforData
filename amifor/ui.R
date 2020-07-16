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


# Define UI for application that draws a histogram
# shinyUI(
#     dashboardPage(
#         dashboardHeader(title = 'Amifor'),
#         dashboardSidebar(
#             #menuItem('Dashboard'),
#             #menuItem('Detailed Analysis')
#         ),
#         dashboardBody(
#             fluidRow(
#                 box(plotOutput('plot1'))
#             )
#         )
#     )
# )

shinyUI(
    fluidPage(
        titlePanel('Amifor Dashboard'),
        mainPanel(plotlyOutput('plot1'),plotlyOutput('plot2'),
                  plotlyOutput('plot3'),plotlyOutput('plot4'),
                  plotlyOutput('plot5'))
        
    )
)

