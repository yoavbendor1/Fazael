#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#library(data.table)
library(RColorBrewer)
library(extrafont)
#library(rapport)
library(shinyWidgets)
#library(pracma)
library(grDevices)
library(Cairo)
library(svglite)
library(ggtern)
library(plotly)
library(tidyverse)
library(ggplot2)

#shinyOptions(shiny.maxRequestSize=1000*1024^2)
options(shiny.maxRequestSize=1000*1024^2)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    inFile <- reactive({
        if (is.null(input$input_file)) {
            return(NULL)
        } else {
            input$input_file
        }
    })
    
    
    myData <- reactive({
        if (is.null(inFile())) {
            return(NULL)
        } else {
            
            tmp_table = read_csv(inFile()$datapath)
            # tmp_table = read_csv('Fazael_grain_size.csv')
            
            big_table=tmp_table
            
            # modify the factor columns into factors
            big_table$sample_name <- factor(big_table$sample_name)
            big_table$site <- factor(big_table$site)
            big_table$fraction <- factor(big_table$fraction)
            
            # remove NA rows
            big_table=big_table[!is.na(big_table$sample_name),]
            
            # make sure the table was loaded correctly
            #  output$table <- renderTable((big_table))
            
            return(big_table)
        }
    })
    
    
    
    observe({
        updatePickerInput(
            session,
            "color_variable",
            choices = c('none',names(myData())[1:3]),
            selected = 'none')
    })
    
    observe({
        updatePickerInput(
            session,
            "selected_site",
            choices = levels(myData()$site),
            selected = levels(myData()$site[1:length(myData()$site)]))
    })
    
    observe({
        updatePickerInput(
            session,
            "selected_sample_name",
            choices = levels(myData()$sample_name),
            selected = levels(myData()$sample_name[1:length(myData()$sample_name)]))
    })
    
    observe({
        updatePickerInput(
            session,
            "selected_fraction",
            choices = levels(myData()$fraction),
            selected = levels(myData()$fraction[1:length(myData()$fraction)]))
    })
    
    myPlot <- function(){
        # make sure the data exists
        req(myData())
        
        big_table=myData()
        
        # output$table <- renderTable(big_table)
        
        # filter the data based on user selection
        big_table = filter(big_table,sample_name %in% input$selected_sample_name)
        big_table = filter(big_table,site %in% input$selected_site)
        big_table = filter(big_table,fraction %in% input$selected_fraction)
        
        p =  big_table %>% 
            ggtern(aes_string(x=colnames(big_table)[4],y=colnames(big_table)[5],z=colnames(big_table)[6])) +
            geom_point(size=input$point_size)  
            # scale_color_brewer(palette = "Paired")
        
        if (!(input$color_variable %in% c("none"))) {
            p = p +
                geom_point(aes_string(color=input$color_variable))
        }
        
        p = p+  
            theme_light()
        
        if (input$add_color_theme) {
            p = p+  
                theme_rgbw()
        } 
        
        p+
            theme(
                #axis.title=element_text(size=14),
                axis.text=element_text(size=14))+
            xlab(input$x_title)+
            ylab(input$y_title)+
            zlab(input$z_title)
        
    }
    
    
    output$plot1 <- renderPlot({
        print(myPlot())
    })
    
    
    output$download_plot_png <- downloadHandler(
        filename = function() { paste(input$figure_name, '.png', sep='')},
        
        content = function(file) {
            ggsave(file,plot = myPlot(), device = "png",width = input$figure_width, height = input$figure_height, units = "cm",limitsize = FALSE,dpi = input$figure_dpi)
        }
    )
    
    output$download_plot_pdf <- 
        downloadHandler(
            filename = function(){ paste(input$figure_name,'.pdf', sep='')},
            content = function(file) {
                ggsave(file,plot = myPlot(), device = cairo_pdf(),width = input$figure_width, height = input$figure_height, dpi = input$figure_dpi, units = "cm")
            }
        ) 
    
    output$download_plot_svg <- 
        downloadHandler(
            filename = function(){
                paste(input$figure_name,'.svg', sep='')
            },
            
            content = function(file) {
                ggsave(file,plot = myPlot(), device = svg,width = input$figure_width, height = input$figure_height, dpi = input$figure_dpi, units = "cm")
            }
        )  
    
})
