box(title = "1. Temperature data", width = 12, solidHeader = T, status = "primary", 
    fluidRow(
      
      conditionalPanel(
        "input.inputMode != 'thermalUnfolding'",
      
        column(7,p(
          HTML("<b>Oligomeric state</b>"),
          span(shiny::icon("info-circle"), id = "ui_oligomeric_state_term"),
          selectInput('oligomeric_state_term',NULL,
                      choices = c('Monomer'      = 'monomer',
                                  'Homodimer'    = 'dimer',
                                  'Homotrimer'   = 'trimer',
                                  'Homotetramer' = 'tetramer')),
          tippy::tippy_this(
            elementId = "ui_oligomeric_state_term",
            tooltip = "Select if you want to apply unfolding models for monomers,
            dimers, trimers, or tetramers. In the last three cases, you need to input the 
            concentration of the n-mer equivalent, in micromolar units.",
            placement = "right")
          
        )),

        # Slider input for the temperature range
        column(5,p(
          HTML("<b>Temperature range</b>"),
          span(shiny::icon("info-circle"), id = "ui_temperature_range"),
          sliderInput('temperature_range', NULL,
                      min = 0, max = 110, value = c(5, 95), step = 1,
                      post = " °C", width = '100%'),
          tippy::tippy_this(
            elementId = "ui_temperature_range",
            tooltip = "Select the temperature range of interest. The table below will update automatically",
            placement = "right"))),

        column(width = 12,rHandsontableOutput('thermal_denaturation_data'))
        )
      
    ))

