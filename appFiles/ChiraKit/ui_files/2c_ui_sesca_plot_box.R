box(title = "Plotting options", width = 12, solidHeader = T, status = "primary",

    conditionalPanel('input.secStr_analysis_mode == "SESCA_pred"',

        conditionalPanel('input.sescaReference != "None"',

            fluidRow(

                column(3, p(HTML("<b>Ref. label</b>"),
                    textInput("sesca_pred_ref_name", NULL,'reference')))

            )

        )

    ),

    fluidRow(

        column(3, p(HTML("<b>File type</b>"),
                    selectInput("sesca_plot_type", NULL,
                                c("PNG"    = "png",
                                  "SVG"    = "svg",
                                  "JPEG"    = "jpeg")))),

        column(3, p(HTML("<b>Width</b>"),
                    span(shiny::icon("info-circle"), id = "info_uuPlotWidthSESCA"),
                    numericInput('sesca_plot_width',NULL, 12,min = 1, max = 100),
                    tippy::tippy_this(elementId = "info_uuPlotWidthSESCA",
                                      tooltip = "Units are pixels * 50",placement = "right"))),

        column(3, p(HTML("<b>Height</b>"),
                    span(shiny::icon("info-circle"), id = "info_uuPlotHeightSESCA"),
                    numericInput('sesca_plot_height',NULL, 11,min = 1, max = 100),
                    tippy::tippy_this(elementId = "info_uuPlotHeightSESCA",
                                      tooltip = "Units are pixels * 50",
                                      placement = "right"))),

        column(3, p(HTML("<b>Text size</b>"),
                    numericInput('sesca_axis_size',NULL, 16,min = 4, max = 40)))

    ),

    conditionalPanel('input.secStr_analysis_mode == "SESCA_pred"',

        fluidRow(

            column(3, p(HTML("<b>Show X-grid</b>"),checkboxInput('sesca_show_x_grid',NULL, value = TRUE))),
            column(3, p(HTML("<b>Show Y-grid</b>"),checkboxInput('sesca_show_y_grid',NULL, value = TRUE))),

            column(3, p(HTML("<b>Marker size</b>"),
                numericInput('sesca_marker_size',NULL, value = 4,min=0.5, max = 10,step=0.25))),

            column(3, p(HTML("<b>Line width</b>"),
                numericInput('sesca_line_width',NULL, value = 1,min=0.2, max = 10,step=0.2)))

        )

    ),

    conditionalPanel('input.secStr_analysis_mode == "SESCA_est"',

        fluidRow(

        column(3, p(HTML("<b>Posterior probability X-axis</b>"),
                numericInput('sesca_bayes_pp_x',NULL, 1,min = 1, max = 6))),

        column(3, p(HTML("<b>Posterior probability Y-axis</b>"),
                numericInput('sesca_bayes_pp_y',NULL, 2,min = 1, max = 6))),

        )

    )


)