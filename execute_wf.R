#!/usr/bin/env Rscript
#
# execute_wf -> RSeqFlow
# Gonzalo Claros
# 2025-01-13
#
# Main file, invoked after source(configure_wf.R)
# Alternative usage from terminal: Rscript execute_wf.R aConfigFile.R 

T00 <- proc.time() # Initial time for elaspsed time

# %%%%%%%%%%%%%%%%%%%%%%%%%
# RETRIEVE ARGS if ANY ####
# %%%%%%%%%%%%%%%%%%%%%%%%%

errMsg <- "ERROR:\nThe pipeline must be launched as 'Rscript execute_wf.R aConfigFile.R'\n       or as 'source(configure_wf.R)'\n"

## by default, okMsg refers to sourcing the configuration file ####
okMsg <- "The pipeline was sourced as interactive from 'configure_wf.R'"

## retrieve inputs to the script when given ####
ARGS <- commandArgs(trailingOnly = TRUE) # Test if there is one input argument
if (length(ARGS) >= 1) { 
  # non interactive session with one argument that should be a config file
  message("ARGS ≥ 1: the argument will be treated as configuration file\n")
  # redefinition of okMsg for terminal execution
  okMsg <- paste0("The pipeline was launched from terminal using ", ARGS[1], " as configuration file")
  # load the corresponding configuration parameters
  source(ARGS[1])
} else if (!(interactive())) {
  warning("No argument (configuration file) supplied\n")
  stop(errMsg, call. = FALSE)
} else if (!("MIN_CPM" %in% ls())) {
  stop(errMsg, call. = FALSE)
} else {
  message("The pipeline may be reading VARIABLES from RAM instead of configuration file")
}

if (interactive()) {
	cat("This is an INTERACTIVE session\n")
} else {
	cat("The pipeline was launched from the COMMAND-LINE terminal\n")
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# SOME PARAMETER VERIFICATION ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Exception errors ####
if (!file.exists(DATA_DIR)) {
  errMsg <- paste0("ERROR:\n", "** Folder ", DATA_DIR, 
                " defined in configuration variable DATA_DIR does not exist for user ", Sys.getenv("LOGNAME"), " **\n")
  # salir del programa para arreglar el error
  stop(errMsg, call. = FALSE)
}

if (!(exists("COUNTS_COLUMN") | exists("LAST_COLUMN"))) stop("ERROR:\nThe configuration file is old and does not contain COUNTS_COLUMN o LAST_COLUMN variables", call. = FALSE)

if (!exists("NODE_MAX")) stop("ERROR:\nThe configuration file is old and does not contain NODE_MAX variable", call. = FALSE)
if (NODE_MAX > 700) stop("ERROR:\nNODE_MAX value (", NODE_MAX, ") is too high and execution time will take hours unnecessarily", call. = FALSE)

## checking other configuration values ####
theVar <- vector()
if (MIN_CPM < 0) theVar <- c(theVar, "MIN_CPM")
if (CV_MIN < 0) theVar <- c(theVar, "CV_MIN")
if (FC < 0) theVar <- c(theVar, "FC")
if (P < 0 | P > 0.5) theVar <- c(theVar, "P")       # P is negative or too high
if (OPT_CLUST < 0) theVar <- c(theVar, "OPT_CLUST")
if (MIN_GENES_PER_CLUSTER < 0) theVar <- c(theVar, "MIN_GENES_PER_CLUSTER")

if (length(theVar) > 0) stop("ERROR:\n   In 'configure' file: \n", toString(theVar), " must be >0 ", call. = FALSE)


# remove needless variable
rm(theVar, errMsg)



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# LOAD LIBRARIES/PACKAGES ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileToSource <- paste0(SOURCE_DIR, "libraries_wf.R")
source(fileToSource)


# %%%%%%%%%%%%%%%%%%%
# LOAD FUNCTIONS ####
# %%%%%%%%%%%%%%%%%%%

fileToSource <- paste0(SOURCE_DIR, "functions_wf.R")
source(fileToSource)

# remove needless variables
rm(fileToSource)


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DECLARE USER-INDEPENDENT VARIABLES AND CONSTANTS ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## this should be changed every time you produce a main change ####
SOFT_NAME <- "RSeqFlow"
VERSION_CODE <- 1.04

## get computer type ####
COMPUTER <- GetComputer()

## variable to customise each working directory created ####
HOY <- format(Sys.time(), "%F_%H.%M.%S")

## create working directory to save results ####
cat("\n*** Creating directory for results *** \n")
WD <- CreateDir(DATA_DIR, SOFT_NAME, VERSION_CODE)

## construct the list with columns to read the input file ####
# It will depend on the DATA_FILES definition
if (length(DATA_FILES) == 1) {
	COLUMNS_TO_READ <- FIRST_COLUMN:LAST_COLUMN # the range of columns
	rm(FIRST_COLUMN, LAST_COLUMN)
} else {
	COLUMNS_TO_READ <- c(1, COUNTS_COLUMN) # individual files with counts
	rm(COUNTS_COLUMN)
}

## set number of decimals for rounding ####
ROUND_dig <- 3 

## convert experimental conditions into factors ####
EXP_FACTORS <-  factor(EXP_CONDITIONS)

## frequency of every condition ####
COND_FREQ <- table(EXP_CONDITIONS)

# remove needless variables
rm(EXP_CONDITIONS)

## convert CONTRASTS list into the required vector of contrasts ####
i <- 1
allContrasts <- c()
for (i in 1:length(CONTRASTS)) {
  allContrasts <- c(allContrasts, 
                    paste0(CONTRASTS[[i]][1], 
                           "-",
                           CONTRASTS[[i]][2])
  )
}

## Set the log2 of fold-change ####
logFC <- log2(FC)

## set correlation parameters ####
# Set correlation method pearson or spearman
CORR_METHOD = "spearman"
# Set correlation threshold considering that r^2 = (0,75)^2 = 0,5625
R_MIN <- 0.75

## Set code-folding for Rmd
# my_codefolding <- ifelse(VERBOSE_MODE, "show", "hide")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MAIN EXECUTION USING MARKDOWN ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## set workind directory ####
setwd(WD)

## launch rmarkdown report ####
cat("\n*** Creating markdown report ***\n")

# the Rmd file must be located with code
loadRmd <- paste0(SOURCE_DIR, "Report_", SOFT_NAME, ".Rmd")

# the resulting HTML should be be saved with the results, not with code
render(input = loadRmd, 
       output_dir = WD,
       output_file = " Report.html",
       output_format = html_document(theme = "cerulean",
                                     number_sections = FALSE,
                                     # code_folding = my_codefolding,
                                     toc = TRUE,
                                     toc_depth = 4,
                                     toc_float = TRUE),
       quiet = TRUE)

# %%%%%%%%%%%%%%%%%%
# END MAIN CODE ####
# %%%%%%%%%%%%%%%%%%

message(paste0("\n", SOFT_NAME, " v", VERSION_CODE, " report successfully completed."))
cat("\n", "*** Report and results saved in the following folder: ***", "\n")
message(WD)

T_total2 <- proc.time() - T00
message("\nReal time taken by the current run: ", round(T_total2[[3]]/60, digits = 3), " min")
print(T_total2)