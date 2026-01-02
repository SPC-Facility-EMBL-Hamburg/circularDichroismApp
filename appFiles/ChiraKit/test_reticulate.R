rm(list=ls())
gc()
library(reticulate)
library(reshape2)
library(tidyverse)
library(plotly)
#library(factoextra)


appName     <- "ChiraKit"
user        <- Sys.info()['user']

reticulate::use_python(paste0("/Users/",user,"/myenv/bin/python"), required = TRUE)
base_dir <- paste0("/Users/",user,"/Desktop/arise/circularDichroismApp/appFiles/",appName,"/")
setwd(base_dir)

# List of Python script files to source
py_scripts <- c("cdAnalyzer.py","helpers.py","decomposition_helpers.py",
                "fitting_helpers.py")

# Source the Python helper functions
for (script in py_scripts) {source_python(paste0('python_src/', script))}

# List of R script files to source
r_scripts <- c("helpers.R","helpers_unfolding.R","helpers_plotting.R","plotFunctions.R","plotFunctionsSpectraComparison.R")

# Source the R helper functions
for (script in r_scripts) {source(paste0('server_files/', script))}


cdAnalyzer <- CdAnalyzer()
cdAnalyzer$load_experiment('./www/Lys-Tscan-Oct2024_20241101.csv','test')

l1 <- list(test='millidegrees')

cdAnalyzer$experiments_to_absorbance_units(l1)
cdAnalyzer$experiments_absorbance_units_to_other_units(l1)
cdAnalyzer$initialize_experiment_modif()

relevant_temperature <- c(
  24.2, 26.6, 28.9, 31.3, 33.6, 35.9, 38.2, 40.5, 42.8,
  45.2, 47.5, 49.8, 52.1, 54.4, 56.8, 59.1, 61.4, 63.7,
  66, 68.4, 70.7, 73, 75.3, 77.6, 80, 82.3, 84.6
)

relevant_spectra <- paste0('test ', relevant_temperature)

cdAnalyzer$experimentsOri[['test']]$internalID <- relevant_spectra

merged <- get_signal_dfs_from_selected_spectra(relevant_spectra,cdAnalyzer)

sorted_indexes      <- order(relevant_temperature)

relevant_temperature <- relevant_temperature[sorted_indexes]

sorted_signal   <- as.matrix(merged[,-1][,sorted_indexes],drop = FALSE)

group <- 'Thermal unfolding 1'

cdAnalyzer$clean_experiments('thermal')
# Assign the signal and temperature data to the new thermal unfolding experiment
cdAnalyzer$experimentsThermal[[group]]                    <- CdExperimentThermalRamp()
cdAnalyzer$experimentsThermal[[group]]$wavelength         <- np_array(merged[,1])
cdAnalyzer$experimentsThermal[[group]]$signalDesiredUnit  <- np_array(sorted_signal)
cdAnalyzer$experimentsThermal[[group]]$temperature        <- np_array(relevant_temperature)
cdAnalyzer$experimentsThermal[[group]]$temperature_ori    <- np_array(relevant_temperature)
cdAnalyzer$experimentsThermal[[group]]$name               <- group

relevantOligoConc  <- rep(c(1, 2), times = 13)
relevantOligoConc  <- c(relevantOligoConc,1)
relevantOligoConc  <- relevantOligoConc[sorted_indexes]/1e6 # Transform micromolar (user input) to molar
cdAnalyzer$experimentsThermal[[group]]$oligo_conc_molar <- np_array(relevantOligoConc)


cdAnalyzer$experimentsThermal[[group]]$decompose_spectra_svd()
cdAnalyzer$experimentsThermal[[group]]$filter_basis_spectra(99)
cdAnalyzer$experimentsThermal[[group]]$align_basis_spectra_and_coefficients()
cdAnalyzer$experimentsThermal[[group]]$reconstruct_spectra()
cdAnalyzer$experimentNamesThermal <- c(group)


df1 <- get_coefficients_df(cdAnalyzer)
print(head(df1))

cdAnalyzer$experimentsThermal[[group]]$assign_useful_signal_svd(as.integer(2))
cdAnalyzer$experimentsThermal[[group]]$reshape_signal_oligomer('Thermal')


df2 <- get_coefficients_df(cdAnalyzer)
print(head(df2))


for (script in r_scripts) {source(paste0('server_files/', script))}

fig <- plot_unfolding_exp(
  df1,
  'test',
  spectra_decomposition_method='SVD')

fig
