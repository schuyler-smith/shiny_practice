# Load libraries, data -----------------------------------------------
pokemon <- data.table::fread("data/Pokemon.csv")
types <- unique(pokemon$`Type 1`)

# # Page 1 - Introduction ----------------------------------------------
# intro_panel <- tabPanel(
#   "Introduction",
#   titlePanel("Stats of Pokemon"),
#   img(src = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pcgamesn.com%2Fpokemon-pc-game&psig=AOvVaw11FtpxVrn9dwjtj9jmDKtK&ust=1643730143952000&source=images&cd=vfe&ved=0CAgQjRxqFwoTCNDilo6q3PUCFQAAAAAdAAAAABAD", height = 400, width = 800),
#   
#   br(), br(),
#   
#   p("This is me practicing with Shiny! I'm not sure what generation this data is valid for,
#     but pokemon are always fun anyways."),
#   
#   p(a(href = "https://www.kaggle.com/abcsds/pokemon", "Data Source (Kaggle)"))
# )
# 
# # Page 2 - Vizualization -------------------------------------------
# values <- colnames(pokemon)
# stat_categories <- colnames(pokemon[ , .SD, .SDcols = is.numeric])[-c(1,9)]
# 
# sidebar_content <- sidebarPanel(
#   selectInput(
#     "stat_var",
#     label = "Y Variable",
#     choices = stat_categories,
#     selected = 'Total'
#   )
# )
# 
# main_content <- mainPanel(
#   plotOutput("plot")
# )
# 
# second_panel <- tabPanel(
#   "Visualization",
#   titlePanel("Yo title"),
#   p("Use the selector input below to choose which stat you would like to see."),
#   sidebarLayout(
#     sidebar_content, main_content
#   )
# )

dashboard_panel <- dashboardPage(
  dashboardHeader(title = "Pokemon Stats"),
  dashboardSidebar(
    disable = TRUE
  ),
  dashboardBody(
    box(checkboxGroupInput(inputId = "v_type",
                           label = "Type",
                           choices = sort(unique(pokemon$`Type 1`)),
                           selected = unique(pokemon$`Type 1`))),
    box(checkboxGroupInput(inputId = "v_gen",
                           label = "Generation",
                           choices = unique(pokemon$Generation),
                           selected = unique(pokemon$Generation))),
    box(checkboxGroupInput(inputId = "v_legendary",
                           label = "Show Legendary Pokemon",
                           choices = c("Non-legendary"=FALSE, "Legendary"=TRUE),
                           selected = c(FALSE, TRUE))),
    fluidRow(
      box(sliderInput("v_total", 
                      label = "Total",
                      min = min(pokemon$Total), 
                      max = max(pokemon$Total), 
                      value = min(pokemon$Total))),
      box(sliderInput("v_hp", 
                      label = "HP",
                      min = min(pokemon$HP), 
                      max = max(pokemon$HP), 
                      value = min(pokemon$HP))),
      box(sliderInput("v_attack", 
                      label = "Attack",
                      min = min(pokemon$Attack), 
                      max = max(pokemon$Attack), 
                      value = min(pokemon$Attack))),
      box(sliderInput("v_defense", 
                      label = "Defense",
                      min = min(pokemon$Defense), 
                      max = max(pokemon$Defense), 
                      value = min(pokemon$Defense))),
      box(sliderInput("v_spattack", 
                      label = "Special Attack",
                      min = min(pokemon$`Sp. Atk`), 
                      max = max(pokemon$`Sp. Atk`), 
                      value = min(pokemon$`Sp. Atk`))),
      box(sliderInput("v_spdef", 
                      label = "Special Defense",
                      min = min(pokemon$`Sp. Def`), 
                      max = max(pokemon$`Sp. Def`), 
                      value = min(pokemon$`Sp. Def`))),
      box(sliderInput("v_speed", 
                      label = "Speed",
                      min = min(pokemon$Speed), 
                      max = max(pokemon$Speed), 
                      value = min(pokemon$Speed)))),
      DT::dataTableOutput("pokemon_list")
  ))

ui <- navbarPage(
  "Pokemon Stats",
  # intro_panel,
  # second_panel,
  dashboard_panel
)

