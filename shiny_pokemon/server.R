library(ggplot2)

pokemon <- data.table::fread("data/Pokemon.csv")

server <- function(input, output) {
  
  # reactive(data.table::setkeyv(pokemon, input$stat_var))
  # reactive(data.table::set(pokemon, j='Name', 
  #                          value=factor(pokemon$Name, levels = pokemon$Name)))
  # output$plot <- renderPlot({
  #   ggplot(data=pokemon, aes_string(x='Name', y=input$stat_var, fill="Legendary")) +
  #     geom_bar(stat="identity", width=0.8) +
  #     labs(x="Pokemon", y=input$stat_var) + 
  #     coord_flip()
  # })

  
  output$pokemon_list <- DT::renderDataTable(pokemon[Total >= input$v_total & 
                                                       HP >= input$v_hp & 
                                                       Attack >= input$v_attack & 
                                                       Defense >= input$v_defense &
                                                       `Sp. Atk` >= input$v_spattack &
                                                       `Sp. Def` >= input$v_spdef &
                                                       Speed >= input$v_speed &
                                                       Generation %in% input$v_gen &
                                                       `Type 1` %in% input$v_type &
                                                       Legendary %in% input$v_legendary
                                                       ])

}

