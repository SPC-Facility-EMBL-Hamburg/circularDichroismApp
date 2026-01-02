append_record_to_logbook <- function(record_str,include_time=FALSE) {

    if (include_time) {
        record_str <- paste0(as.character(format(Sys.time(),usetz = TRUE)),' ',record_str)
    }
    # Append '' to print in the output a new empty line after the record
    record_str <- c(record_str,'')

    reactives$logbook <- append(reactives$logbook, record_str)

    return(NULL)
}

updateSESCA_ref <- function(legendDf) {

    spectraLegends        <- c('None',legendDf$Internal.ID)
    names(spectraLegends) <- c('None',legendDf$Legend)

    updateSelectInput(session,"sescaReference",NULL,choices=spectraLegends)
    updateSelectInput(session,"sescaReferenceEstimation",NULL,choices=spectraLegends[-1])
}

updateProcessingTable <- function(operation = 'Sum',operationUnits='millidegrees') {

    # Generate table to preprocess spectra (subtract, sum, smooth, average, etc.)
    df <- generateDTtableProcessing(cdAnalyzer,operation,operationUnits)

    # To allow the creation of selectInput inside DT table
    session$sendCustomMessage('unbind-DT', 'proccesingInfo')
    output$proccesingInfo <- renderDTtable(df)

}

updateCDFilesInfoTable <- function() {

    df <- generateDTtable(cdAnalyzer)

    # To allow the creation of selectInput inside DT table
    session$sendCustomMessage('unbind-DT', 'cdFilesInfo')
    output$cdFilesInfo <- renderDTtable(df,TRUE)

    Sys.sleep(0.5)

    observeEvent(
        lapply(1:length(cdAnalyzer$experimentNames), function(i) input[[paste0("inputUnits", i)]]),
        {
            reactives$data_loaded <- NULL
            convertExperimentToWorkingUnits()
            reactives$data_loaded <- TRUE
        },
        ignoreInit = T,
        ignoreNULL = T
    )
}

updateMaxVoltageValue <- function() {
    allVoltageData <- unlist(cdAnalyzer$get_experiment_properties('signalHT'))
    maxVoltage     <- max(c(allVoltageData,0),na.rm = T)

    reactives$showVoltageThreshold <- maxVoltage > 0

    updateNumericInput(session,'maxHTvalue',NULL,value = maxVoltage)
}

output$showVoltageThreshold   <- reactive( { return( reactives$showVoltageThreshold  ) } )
outputOptions(output, "showVoltageThreshold" , suspendWhenHidden = FALSE)

load_one_experiment <- function(cd_data_file,name,inputUnits = 'millidegrees') {

    nameOri <- name
    name    <- remove_file_extension(name)

    # Remove ':' which will break our app
    name <- gsub(':','',name)

    withBusyIndicatorServer("Go",{

        exps      <- cdAnalyzer$experimentNames

        if (name %in% exps) {
            shinyalert(text = paste("<b>File name is already being used.</b>"),
            type = "warning",closeOnEsc = T,closeOnClickOutside = T,
            html=T)
            return(NULL)
        }

        load <- cdAnalyzer$load_experiment(cd_data_file,name)

        # Catch exception when file has wrong format/data
        if (!load[[1]]) {
            popUpWarning(paste0("<b>",load[[2]],"</b>"))
            return(NULL)
        }

        l1        <- list()

        # Case 1 - Override default units
        if (inputUnits != 'millidegrees') {
            l1[[1]]   <- inputUnits
        # Case 2 - Use experiments units
        } else {
            l1[[1]]   <- cdAnalyzer$experimentsOri[[name]]$units
        }

        names(l1) <- c(name)

        # Convert to absorbance
        cdAnalyzer$experiments_to_absorbance_units(l1)

        # Convert to desired units
        l1[[1]]   <- input$workingUnits
        cdAnalyzer$experiments_absorbance_units_to_other_units(l1)

        metadata_info     <- cdAnalyzer$experimentsOri[[name]]$metadata

        tabP <- tabPanel(name,value=name,fluidRow(column(12,tableOutput(paste0('metadata_',name)))))

        appendTab("metadata",tabP,select=TRUE)

        if (length(metadata_info) > 0) {

            metadataFeature <- (names(metadata_info))
            metadataValue   <- unlist(metadata_info)

            metadata_df <- data.frame(metadataFeature,metadataValue)
            colnames(metadata_df) <- c('Metadata feature (read from file)','Value')

        } else {
            metadata_df <- data.frame('Metadata'='No information available')
        }

        output[[paste0('metadata_',name)]] <- renderTable({metadata_df})
        Sys.sleep(0.02)
        updateProcessingTable()
        Sys.sleep(0.02)

    })

    append_record_to_logbook(paste0('File loaded: ',nameOri,' | Input units: ',inputUnits),include_time = TRUE)

}

observeEvent(input[["inputUnitsAll"]],{
    req(reactives$data_loaded)

    reactives$data_loaded <- NULL
    convertExperimentToWorkingUnits()
    reactives$data_loaded <- TRUE
},ignoreInit = T,ignoreNULL = T)