#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(readr)
library(gt)

source("funs/helper_funs.R")

seattle_kraken <- read_csv('data/seattle_kraken.csv')
seattle_kraken_stats <- read_rds("data/kraken_player_stats.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # Reactive Data
    player_data <- reactive({ seattle_kraken %>%
            filter(player == input$choose_player)

    })


    player_stats <- reactive({
      
      pluck(seattle_kraken_stats, input$choose_player, 'result')
      
      
    })



    # Player Display
    output$playerImg <- renderImage({

        filename <- list.files("img") %>%
            str_subset(input$choose_player) %>%
            paste0("img/", .)

        list(src = filename)

    }, deleteFile = FALSE)


    output$playerName <- renderText({
        paste0(player_data()$player, " | #", player_data()$number)
    })


    output$playerInfo <- renderText({
        paste0(
        "<ul>
        <li><strong>Birthplace: </strong>", player_data()$full_birthplace, "</li>
        <li><strong>Born (Age): </strong>", player_data()$myd_date, " (",player_data()$age, ")</li>
        <li><strong>Weight: </strong>", player_data()$wt, " lbs</li>
        <li><strong>Height: </strong>", player_data()$ht, "</li>
        <li><strong>Position: </strong>", player_data()$pos_name, "</li>
        <li><strong>Shoots: </strong>", player_data()$sh, "</li>
        </ul>")
    })




    # gt() table output
    gt_tbl <- reactive({
      
      
      player_stats() %>% 
        kraken_tbl()
      
      })


    output$stat_tbl <- render_gt(
        expr = gt_tbl()
    )

})


