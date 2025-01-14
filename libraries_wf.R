# libraries_wf -> RSeqFlow
# Gonzalo Claros
# 2025-01-14

# Already installed packages
# more details https://www.r-bloggers.com/an-efficient-way-to-install-and-load-r-packages/
intalled_libs <- rownames(installed.packages())

# %%%%%%%%%%%%%%
# FROM CRAN ####
# %%%%%%%%%%%%%%

## Listing packages as vectors ####
cat("\n*** Checking CRAN libraries that must be installed ***\n")
libs_general <- c("ggplot2", "gridExtra", "tidyverse", "ggpubr", "scales", "reshape2", "plotly")
libs_diagramas_Venn <- c("ggvenn", "gplots", "VennDiagram", "grid", "futile.logger")
libs_Rmd <- c("knitr", "knitcitations", "rmarkdown", "markdown", "bibtex", "DT")
libs_clustering <- c("igraph", "psych", "corrplot", "cluster", "NbClust", "dendextend",
                      "pheatmap", "factoextra", "fpc", "mclust", "visNetwork", "dynamicTreeCut")

from_CRAN <- c(libs_general, 
               libs_diagramas_Venn, 
               libs_Rmd, 
               libs_clustering)
                   
# remove needless variables
rm(libs_general, libs_diagramas_Venn, libs_Rmd, libs_clustering)

## Obtain absent libraries that must be installed ####
# libraries not pressent in 'intalled_libs'
new_libs_CRAN <- from_CRAN[!(from_CRAN %in% intalled_libs)]

## InstalL and/or update CRAN libraries ####
# installation provided that 'new_libs_CRAN' vector is not empty
if (length(new_libs_CRAN)) {
  # install absent packages
  install.packages(new_libs_CRAN, dependencies = TRUE)
  message(paste("Following", length(new_libs_CRAN), "CRAN libraries were installed at\n    ", R.home()))
  message(new_libs_CRAN, sep = ", ")
} else if (PKG_UPDATE) {
	update.packages(ask = FALSE, checkBuilt = TRUE)
} else {
	cat("\n*** Everything is updated ***\n")
}

## Load libraries ####
# without the outuput when loading a package
silent <- lapply(from_CRAN, require, character.only = TRUE)

# remove needless variables
rm(from_CRAN, new_libs_CRAN)



# %%%%%%%%%%%%%%%%%%%%%%
# FROM Bioconductor ####
# %%%%%%%%%%%%%%%%%%%%%%

cat("\n*** Checking Bioconductor libraries that must be installed  ***\n")

## Checking if BiocManager was installed ####
# Install BiocManager before installing any BioConductor library
if (!("BiocManager" %in% intalled_libs)) install.packages("BiocManager")

## BiocManager installation or update ####
if (PKG_UPDATE) {
	BiocManager::install(ask = FALSE)  # basic installing
}

# Installed Bioconductor version:
VERSION_BIOC <- BiocManager::version()
 
## Bioconductor packages required ####
from_BioC <- c("gplots",
               "RColorBrewer",
               "GO.db",
               "chromPlot", 
               "limma", 
               "edgeR",
               "impute",
               "preprocessCore")
                    
## Absent libraries requiring installation ####
# libraries not pressent in 'intalled_libs'
nuevos_BioC <- from_BioC[!(from_BioC %in% intalled_libs)]

## Install and/or updated Bioconductor libraries ####
# installation provided that 'nuevos_BioC' vector is not empty
if (length(nuevos_BioC)) {
    BiocManager::install(nuevos_BioC, ask = FALSE)
    message(paste(sep = "", "INSTALLED ", length(nuevos_BioC), " BioConductor libraries ", VERSION_BIOC))
    message(nuevos_BioC, sep = ", ")
} else {
	message("\nBioConductor ", VERSION_BIOC, " update not required")
}

## Load libraries ####
silent <- lapply(from_BioC, require, character.only = TRUE)

# remove needless variables
rm(intalled_libs, from_BioC, nuevos_BioC, silent)

cat("\n*** All libraries installed and loaded. *** \n")
message("On your computer, you can find the libraries at\n", .libPaths(), "\n")
