#!/usr/bin/env Rscript
#
# execute_wf -> RSeqFlow
# Gonzalo Claros
# 2025-03-11
#
# Main file, invoked after source(configure_wf.R)
# Alternative usage from terminal: Rscript execute_wf.R aConfigFile.R 

T00 <- proc.time() # Initial time for elaspsed time

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# RETRIEVE ARGUMENTS if ANY ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Error message for wrong launching ####
errMsg <- "ERROR:\nThe pipeline must be launched as 'Rscript execute_wf.R aConfigFile.R'\n       or as 'source(aConfigFile.R)'\n"

# By default, okMsg refers to sourcing the configuration file
okMsg <- "The pipeline was sourced as interactive from 'configure_RSeqFlow.R'"

## Retrieve inputs to the script when given ####
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


# %%%%%%%%%%%%%%%%%%%%%%%%%%
# ARGUMENT VERIFICATION ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%

## Exception errors ####
if (!file.exists(DATA_DIR)) {
  errMsg <- paste0("ERROR:\n", "** Folder ", DATA_DIR, 
                " defined in configuration variable DATA_DIR does not exist for user ", Sys.getenv("LOGNAME"), " **\n")
  # salir del programa para arreglar el error
  stop(errMsg, call. = FALSE)
}

if (!(exists("COUNTS_COLUMN") | exists("LAST_COLUMN"))) stop("ERROR:\nThe configuration file is old and does not contain COUNTS_COLUMN or LAST_COLUMN or DoCLUSTER_NETWORK variables", call. = FALSE)

if (!exists("DoCLUSTER_NETWORK")) stop("ERROR:\nThe configuration file is old and does not contain DoCLUSTER_NETWORK variable", call. = FALSE)

if (!exists("NODE_MAX")) stop("ERROR:\nThe configuration file is old and does not contain NODE_MAX variable", call. = FALSE)
if (NODE_MAX > 700) stop("ERROR:\nNODE_MAX value (", NODE_MAX, ") is too high and execution time will take hours unnecessarily", call. = FALSE)

## Checking other configuration values ####
theVar <- vector()
if (MIN_CPM < 0) theVar <- c(theVar, "MIN_CPM")
if (CV_MIN < 0) theVar <- c(theVar, "CV_MIN")
if (FC < 0) theVar <- c(theVar, "FC")
if (P < 0 | P > 0.5) theVar <- c(theVar, "P")       # P is negative or too high
if (OPT_CLUST < 0) theVar <- c(theVar, "OPT_CLUST")
if (MIN_GENES_PER_CLUSTER < 0) theVar <- c(theVar, "MIN_GENES_PER_CLUSTER")

if (length(theVar) > 0) stop("ERROR:\n   In 'configure' file: \n", toString(theVar), " must be >0 ", call. = FALSE)

rm(theVar, errMsg)   # remove needless variable



# %%%%%%%%%%%%%%%%%%%
# LOAD R MODULES ####
# %%%%%%%%%%%%%%%%%%%

## Load libraries ####
fileToSource <- paste0(SOURCE_DIR, "libraries_wf.R")
source(fileToSource)

## Load functions ####
fileToSource <- paste0(SOURCE_DIR, "functions_wf.R")
source(fileToSource)

rm(fileToSource)   # remove useless variable


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DECLARE USER-INDEPENDENT VARIABLES AND CONSTANTS ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Pipeline name and version ####
# this should be changed every time you produce a main change
SOFT_NAME <- "RSeqFlow"
VERSION_CODE <- "1.1.1"

## Computer type ####
COMPUTER <- GetComputer()

## Datetime to customise working directory ####
# this avoids overwriting previous results
HOY <- format(Sys.time(), "%F_%H.%M.%S")

## Create working directory ####
# this is the folder where the results will be saved, next to the data files
cat("\n*** Creating directory for results *** \n")
WD <- CreateDir(DATA_DIR, SOFT_NAME, VERSION_CODE)

## Construct the list with columns to read the input file ####
# It will depend on the DATA_FILES definition
if (length(DATA_FILES) == 1) {
	COLUMNS_TO_READ <- FIRST_COLUMN:LAST_COLUMN # the range of columns
	rm(FIRST_COLUMN, LAST_COLUMN)               # remove needless variables
} else {
	COLUMNS_TO_READ <- c(1, COUNTS_COLUMN)      # individual files with counts
	rm(COUNTS_COLUMN)                           # remove needless variable
}

## Set number of decimals for rounding ####
options(digits = 3)      # set the number of digits to display
ROUND_dig <- 3           # set the number of digits to round

## Convert experimental conditions into factors ####
EXP_FACTORS <-  factor(EXP_CONDITIONS)
rm(EXP_CONDITIONS)      # remove needless variable

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

## Set correlation parameters ####
# Spearman method is more appropriate for biological data
CORR_METHOD = "spearman"
# Set correlation threshold considering that r^2 = (0,75)^2 = 0,5625
R_MIN <- 0.75

## Colouring palettes ####
# for heatmaps
HEATMAP_COLORS <- hcl.colors(99, "RdBu", rev = TRUE)
HEATMAP_COLORS2 <- colorRampPalette(rev(brewer.pal(n = 11, name ="RdBu")), interpolate = "spline")(99)
HEATMAP_COLORS_BWR <- colorRampPalette(c("blue", "white", "red"))(256)

# for Venn diagrams
VENN_COLORS <- c("steelblue", "#EFC000FF", "#CD534CFF", "plum", "#868686FF")


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MAIN EXECUTION USING MARKDOWN ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setwd(WD)       # set the working directory

cat("\n*** Creating markdown report ***\n")

loadRmd <- paste0(SOURCE_DIR,    # the Rmd file must be located with code
                  "Report_", 
                  SOFT_NAME, 
                  ".Rmd")

# the resulting HTML should be be saved with the results, not with code
render(input = loadRmd, 
       output_dir = WD,
       output_file = " Report.html",
       output_format = html_document(theme = "cerulean",
                                     number_sections = FALSE,
                                     code_folding = ifelse(VERBOSE_MODE, "show", "hide"), # "none"
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