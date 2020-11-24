#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
#library(periscope)

# shinyOptions(shiny.maxRequestSize=1000*1024^2)
options(shiny.maxRequestSize=1000*1024^2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Grain Size Analysis"),
    
    plotOutput("plot1",
               width = "1200px",
               height = "400px"),
    
    hr(),
    
    # Sidebar with a slider input for number of bins
    fluidRow(
        column(width = 3,
               offset = 0,
               h4('load and plot'),

               fileInput(inputId='input_file', 
                         label = h5('upload files for analyses'),
                         multiple = TRUE
               ),

               
               pickerInput(
                   inputId = "color_variable",
                   label = "Select color variable", 
                   choices = "",
                   multiple = FALSE
               ),
               
               materialSwitch(
                   inputId = "add_color_theme",
                   label = "color theme", 
                   status = "primary",
                   right = TRUE
               )
               

        ),
               
            
        
        column(width = 2,
               offset = 0,
               h4('data to plot'),
               
               pickerInput(inputId="selected_site",
                           label = h5("sites to plot"),
                           choices="",
                           options = list(`actions-box` = TRUE),multiple = T),

               pickerInput(inputId="selected_sample_name",
                           label = h5("select samples"),
                           choices="",
                           options = list(`actions-box` = TRUE),multiple = T),
               
               pickerInput(inputId="selected_fraction",
                           label = h5("select fraction"),
                           choices="",
                           options = list(`actions-box` = TRUE),multiple = T),
        ),
        
        
        column(width = 2,
               offset = 0,
               h4('plot appearance'),
               
               textInput(inputId="x_title",
                         label = h5("x title"),
                         value="125um < x < 2mm"),
               
               textInput(inputId="y_title",
                         label = h5("y title"),
                         value="63um < x < 125um"),
               
               textInput(inputId="z_title",
                         label = h5("z title"),
                         value="63um < x"),
               
               sliderInput(inputId = "point_size",
                           label = h5("point size"),
                           min=0, max=10,
                           value=1, step=0.25)

        ),
        
        column(width = 3,
               offset = 0,
               h4('download figure'),
               
               sliderInput(inputId="figure_height",
                           label = h5("set figure height [cm]"),
                           min=0,max=30,
                           value=10, step=1),
               
               sliderInput(inputId="figure_width",
                           label = h5("set figure width [cm]"),
                           min=0,max=30,
                           value=20, step=1),
               
               sliderInput(inputId="figure_dpi",
                           label = h5("set dpi"),
                           min=0,max=1000,
                           value=300, step=20),
               
               textInput(inputId="figure_name",
                         label = h5("figure name"),
                         value="triplot fig"),

               downloadButton(outputId='download_plot_png', label='Download PNG Figure'),
               
               downloadButton(outputId='download_plot_pdf', label='Download PDF Figure'),
               
               downloadButton(outputId='download_plot_svg', label='Download SVG Figure')
               
              
        ),
    )
    
)

)
