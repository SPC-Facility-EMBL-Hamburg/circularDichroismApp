# The ChiraKit app

Last time updated: January 2026

## Introduction

ChiraKit is an online multi-purpose tool developed to investigate circular dichroism (CD) data. 

The workflow of ChiraKit is divided into four steps:

1) Data Importing: Upload raw CD data from various instruments (e.g.,'Applied Photophysics' and 'JASCO') and file formats (e.g., .dat, .pcd, .gen). 

2) Preprocessing: Add, subtract, zero, smooth, and/or average the spectra. Choose between different working units, such as millidegrees, differential absorbance, molar extinction, and mean residue molar ellipticity.

3) Analysis: Calculate the protein secondary structure, fit user-defined models, or explore the CD data as a function of a certain experimental parameter. Noteworthy functionalities include two-state models for thermal and chemical unfolding.

4) Export: Export the finalised spectra, fitted parameters, and fitted curves.

Key functionalities:

Secondary Structure Prediction: Apply the Selcon3 algorithm to predict the protein secondary structure by comparing the CD spectrum of interest to a reference set.

Spectra Decomposition: Employ Singular Value Decomposition (SVD) or Principal Component Analysis (PCA) to decompose multiple spectra into a set of basis spectra.

Thermal and Chemical Unfolding: Fit unfolding curves with a reversible two-state model.

Customized Data Analysis: Study the CD signal as a function of any desired experimental parameter.

## Getting started

To run the apps locally you need R (tested with version 4.4.1) and Python (tested with version 3.12.3). Then,

1) Install the required R packages (it may take a long time)

``` bash 
Rscript ./appFiles/install_r_packages.R
```

2) Create a Python environment

``` bash 
user=$(whoami) 
python3 -m venv /home/${user}/myenv
```

3) Install the required Python packages (if you prefer Conda, contact us)

```bash
/home/${user}/myenv/bin/pip install --prefer-binary --no-cache-dir -r ./appFiles/requirements.txt
```

4) Set the correct path (variable 'base_dir') for the app by modifying the global.R file

5) Run ChiraKit

``` R 
cd appFiles/ChiraKit
R -e 'shiny::runApp()'
```

## Acknowledgments

The ChiraKit app is possible thanks to:

R language: R Core Team (2020). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.

R package shiny:   Winston Chang, Joe Cheng, JJ Allaire, Yihui Xie and Jonathan McPherson (2020). shiny: Web Application Framework for R. R package version 1.4.0.2. https://CRAN.R-project.org/package=shiny

R package tidyverse: Wickham et al., (2019). Welcome to the tidyverse. Journal of Open Source Software, 4(43), 1686, https://doi.org/10.21105/joss.01686

R package shinydashboard:   Winston Chang and Barbara Borges Ribeiro (2018). shinydashboard: Create Dashboards with 'Shiny'. R package version 0.7.1. https://CRAN.R-project.org/package=shinydashboard

R package ggplot2:   H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

R package reshape2:   Hadley Wickham (2007). Reshaping Data with the reshape Package. Journal of Statistical Software, 21(12), 1-20. URL http://www.jstatsoft.org/v21/i12/.

R package signal: signal developers (2013). signal: Signal processing. URL:
  http://r-forge.r-project.org/projects/signal/.

R package tippy:   John Coene (2018). tippy: Add Tooltips to 'R markdown' Documents or 'Shiny' Apps. R package version 0.0.1. https://CRAN.R-project.org/package=tippy

R package shinyalert:   Pretty Popup Messages (Modals) in 'Shiny'. R package version 1.1. https://CRAN.R-project.org/package=shinyalert

R package plotly:   C. Sievert. Interactive Web-Based Data Visualization with R, plotly, and shiny. Chapman and Hall/CRC Florida, 2020.

R package rhandsontable:   Jonathan Owen (2018). rhandsontable: Interface to the 'Handsontable.js' Library. R package version 0.3.7. https://CRAN.R-project.org/package=rhandsontable

R package shinyjs:   Dean Attali (2020). shinyjs: Easily Improve the User Experience of Your Shiny Apps in Seconds. R package version 1.1. https://CRAN.R-project.org/package=shinyjs

R package reticulate:   Kevin Ushey, JJ Allaire and Yuan Tang (2020). reticulate: Interface to 'Python'. R package version 1.16. https://CRAN.R-project.org/package=reticulate

R package shinycssloaders:   Andras Sali and Dean Attali (2020). shinycssloaders: Add CSS Loading Animations to 'shiny' Outputs. R package version 0.3. https://CRAN.R-project.org/package=shinycssloaders

R package DT: Xie Y, Cheng J, Tan X (2022). DT: A Wrapper of the JavaScript Library 'DataTables'. R package version 0.25, https://CRAN.R-project.org/package=DT.

R package colourpicker: Attali D (2021). _colourpicker: A Colour Picker Tool for Shiny and for Selecting Colours in Plots_. R package version 1.1.1, <https://CRAN.R-project.org/package=colourpicker>.

Python3.7 language: Van Rossum, G., & Drake, F. L. (2009). Python 3 Reference Manual. Scotts Valley, CA: CreateSpace.

Python package numpy: Travis E, Oliphant. A guide to NumPy, USA: Trelgol Publishing, (2006). Stéfan van der Walt, S. Chris Colbert, and Gaël Varoquaux. The NumPy Array: A Structure for Efficient Numerical Computation, Computing in Science & Engineering, 13, 22-30 (2011), DOI:10.1109/MCSE.2011.37

Python package pandas: Wes McKinney. Data Structures for Statistical Computing in Python, Proceedings of the 9th Python in Science Conference, 51-56 (2010)

Python package scipy: Pauli Virtanen, Ralf Gommers, Travis E. Oliphant, Matt Haberland, Tyler Reddy, David Cournapeau, Evgeni Burovski, Pearu Peterson, Warren Weckesser, Jonathan Bright, Stéfan J. van der Walt, Matthew Brett, Joshua Wilson, K. Jarrod Millman, Nikolay Mayorov, Andrew R. J. Nelson, Eric Jones, Robert Kern, Eric Larson, CJ Carey, İlhan Polat, Yu Feng, Eric W. Moore, Jake VanderPlas, Denis Laxalde, Josef Perktold, Robert Cimrman, Ian Henriksen, E.A. Quintero, Charles R Harris, Anne M. Archibald, Antônio H. Ribeiro, Fabian Pedregosa, Paul van Mulbregt, and SciPy 1.0 Contributors. (2020) SciPy 1.0: Fundamental Algorithms for Scientific Computing in Python. Nature Methods, 17(3), 261-272.