# libraries_wf -> RSeqFlow
# Gonzalo Claros
# 2022-07-15

# Already installed packages
# more details https://www.r-bloggers.com/an-efficient-way-to-install-and-load-r-packages/
intalled_libs <- rownames(installed.packages())

# %%%%%%%%%%%%%%
# FROM CRAN ####
# %%%%%%%%%%%%%%

## Listing packages as vectors ####
writeLines("\n*** Checking CRAN libraries that must be installed ***")
libs_general <- c("ggplot2", "gridExtra", "tidyverse", "ggpubr", "scales", "reshape2")
libs_descomprimir_gz <- c("R.utils", "R.methodsS3", "R.oo")
libs_diagramas_Venn <- c("ggvenn", "gplots", "VennDiagram", "grid", "futile.logger")
libs_Rmd <- c("knitr", "knitcitations", "rmarkdown", "markdown", "bibtex", "DT")
libs_scholar <- "scholar"
libs_anova <- "statmod"
libs_clustering <- c("igraph", "psych", "corrplot", "cluster", "NbClust", "dendextend",
                      "pheatmap", "factoextra", "WGCNA", "fpc", "mclust")
libs_metagen <- c("vegan")

from_CRAN <- c(libs_general, 
               libs_descomprimir_gz, 
               libs_diagramas_Venn, 
               libs_Rmd, 
               libs_scholar, 
               libs_anova,
               libs_clustering, 
               libs_metagen)
                   
# remove needless variables
rm(libs_general, libs_descomprimir_gz, libs_diagramas_Venn, libs_Rmd, libs_scholar, libs_anova, libs_clustering, libs_metagen)

## Obtain absent libraries that must be installed ####
# libraries not pressent in 'intalled_libs'
new_libs_CRAN <- from_CRAN[!(from_CRAN %in% intalled_libs)]

## InstalL and/or update CRAN libraries ####
# installation provided that 'new_libs_CRAN' vector is not empty
if (length(new_libs_CRAN)) {
  # install absent packages
  install.packages(new_libs_CRAN, dependencies = TRUE)
  writeLines(paste("Following", length(new_libs_CRAN), "CRAN libraries were installed at\n    ", R.home()))
  writeLines(new_libs_CRAN, sep = ", ")
} else if (PKG_UPDATE) {
	update.packages(ask = FALSE)
} else {
	message("Everything is updated")
}

## Load libraries ####
sapply(from_CRAN, require, character.only = TRUE)
# to remove the output when loading a package, since it is rarely useful
# lapply(from_CRAN, library, character.only = TRUE) %>% invisible() 

# remove needless variables
rm(from_CRAN, new_libs_CRAN)



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Bioconductor install or update ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# https://www.bioconductor.org/install/

writeLines("\n*** Checking Bioconductor libraries that must be installed  ***")

## Checking if BiocManager was installed ####
# Install BiocManager before installing any BioConductor library
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

## BiocManager installation or update ####
if (PKG_UPDATE) {
	BiocManager::install(ask = FALSE)  # basic installing
}

# Installed Bioconductor version:
VERSION_BIOC <- BiocManager::version()
 
## Vector with required Bioconductor packages ####
from_BioC <- c("edgeR", 
               "limma", 
               "Glimma", 
               "gplots",
               "RColorBrewer",
               "GO.db", "impute",
               "preprocessCore",
               "phyloseq",
               "chromPlot")
                    
## Obtain absent libraries that must be installed ####
# libraries not pressent in 'intalled_libs'
nuevos_BioC <- from_BioC[!(from_BioC %in% intalled_libs)]

## Install and/or updated Bioconductor libraries ####
# installation provided that 'nuevos_BioC' vector is not empty
if (length(nuevos_BioC)) {
    BiocManager::install(nuevos_BioC, ask = FALSE)
    writeLines(paste(sep = "", "INSTALLED ", length(nuevos_BioC), " BioConductor libraries ", VERSION_BIOC))
    writeLines(nuevos_BioC, sep = ", ")
} else {
	message(paste(sep="", "BioConductor ", VERSION_BIOC, " update not required"))
}

## Load libraries ####
sapply(from_BioC, require, character.only = TRUE)

# remove needless variables
rm(intalled_libs, from_BioC, nuevos_BioC)

message("All libraries installed and loaded\n")
