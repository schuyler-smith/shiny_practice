library(shiny)
library(shinydashboard)
library(tidymodels)
library(tidyverse)
library(xgboost)
library(palmerpenguins)

model <- readRDS("penguin_model.RDS")

model$pre$mold$predictors

ui <- dashboardPage(
  dashboardHeader(title = "Palmer Penguins Prediction"),
  dashboardSidebar(
    disable = TRUE
  ),
  dashboardBody(
    box(title = "Predicted Penguin Species",
        solidHeader = TRUE,
        width = 6,
        status = "primary",
        valueBoxOutput("penguin_prediction")),
    box(width = 3, selectInput("v_island", label = "Island",
                               choices = c("Dream", "Torgersen", "Biscoe"))),
    box(width = 3, selectInput("v_sex", label = "Sex",
                               choices = c("male", "female"))),
    box(selectInput("v_year", label = "Year",
                    choices = c("2007", "2008", "2009"))),
    fluidRow(
      box(sliderInput("v_bill_length", label = "Bill Length (mm)",
                      min = 30, max = 60, value = 45)),
      box(sliderInput("v_bill_depth", label = "Bill Depth (mm)",
                      min = 10, max = 25, value = 17)),
    ),
    fluidRow(
      box(sliderInput("v_flipper_length", label = "Flipper Length (mm)",
                      min = 170, max = 235, value = 200)),
      box(sliderInput("v_body_mass", label = "Body mass (g)",
                      min = 2700, max = 6300, value = 4000))
    )
  ))

server <- function(input, output) { 
  
  input_df <-       reactive(tibble(
    "island" = input$v_island,
    "bill_length_mm" = input$v_bill_length,
    "bill_depth_mm" = input$v_bill_depth,
    "flipper_length_mm" = input$v_flipper_length,
    "body_mass_g" = input$v_body_mass,
    "sex" = input$v_sex,
    "year" = as.integer(input$v_year)))
  
  
  output$penguin_prediction <- renderValueBox({
    prediction <- predict(model,input_df())
    
    
    prediction_prob <- predict(model, input_df(), type = "prob") %>% 
      gather() %>% 
      arrange(desc(value)) %>% 
      slice_max(value, n = 1) %>% 
      select(value)
    
    prediction_color <- case_when(prediction$.pred_class == "Adelie" ~ "blue",
                                  prediction$.pred_class == "Gentoo" ~ "red",
                                  TRUE ~ "yellow")
    
    
    valueBox(
      value = paste0(round(100 * prediction_prob$value, 0), "%"),
      subtitle = paste0("Species: ", prediction$.pred_class),
      color = prediction_color,
      icon = icon("snowflake"),
    )
  })  
}

shinyApp(ui, server)