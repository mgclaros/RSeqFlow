#!/usr/bin/env Rscript
#
# execute_wf -> RSeqFlow
# Gonzalo Claros
# 2023-03-21
#
# Main file, invoked after source(configure_wf.R)
# Alternative usage from terminal: Rscript execute_wf.R aConfigFile.R 

T00 <- proc.time() # Initial time for elaspsed time

# %%%%%%%%%%%%%%%%%%%%%%%%%
# RETRIEVE ARGS if ANY ####
# %%%%%%%%%%%%%%%%%%%%%%%%%

errMsg <- "R-SEQ must be launched as 'Rscript execute_wf.R aConfigFile.R'\n       or as 'source(configure_wf.R)'\n"

## by default, okMsg refers to sourcing the configuration file ####
okMsg <- "R-SEQ sourced as interactive from 'configure_wf.R'"

## Retrieve inputs to the script when given ####
ARGS <- commandArgs(trailingOnly = TRUE) # Test if there is one input argument
if (length(ARGS) >= 1) { 
  # non interactive session with one argument that should be a config file
  message("ARGS ≥ 1: the argument will be treated as configuration file\n")
  # redefinition of okMsg for terminal execution
  okMsg <- paste0("R-SEQ was launched from terminal using ", ARGS[1], " as configuration file")
  # load the corresponding configuration parameters
  source(ARGS[1])
} else if (!(interactive())) {
  warning("No argument (configuration file) supplied\n")
  stop(errMsg, call.=FALSE)
} else if (!("MIN_CPM" %in% ls())) {
  stop(errMsg, call.=FALSE)
} else {
  message("The script may be reading VARIABLES from RAM instead of configuration file")
}

if (interactive()) {
	message("This is an INTERACTIVE session")
} else {
	message("R-SEQ launched from the COMMAND-LINE terminal")
}


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

## This should be changed every time you produce a main change ####
SOFT_NAME <- "RSeqFlow"
VERSION_CODE <- 1.0

## get computer type ####
COMPUTER <- GetComputer()

## User ID in the computer ####
YO <- system ("whoami", intern = TRUE)

## Checking data directory defined by users in the 'configure' file ####
if (!file.exists(DATA_DIR)) {
	msg <- paste0(msg, "** Directory ", 
	             DATA_DIR, " does not exist for user ", YO, " **\n")
	# quit script to fix the error
	stop(msg, call. = FALSE)
}

## Checking other configuration values
theVar <- vector()
msg <- " Change it in configure_wf.R"
if (MIN_CPM < 0) theVar <- c(theVar, "MIN_CPM")
if (CV_MIN < 0) theVar <- c(theVar, "CV_MIN")
if (FC < 0) theVar <- c(theVar, "FC")
if (P < 0) theVar <- c(theVar, "P")
if (length(theVar) > 0) stop("\n   ", toString(theVar), " must be > 0.", msg)

if (P > 0.5) stop("\n   P-value ", P, " is too high.", msg)
if (NODE_MAX > 700) stop("\n   NODE_MAX ", NODE_MAX, " is too high. The execution will take hours unnecessarily", msg)

# remove needless variable
rm(theVar)

## variable to customise each working directory created ####
HOY <- format(Sys.time(), "%F_%H.%M.%S")

## create working directory to save results ####
WD <- CreateDir(DATA_DIR, SOFT_NAME, VERSION_CODE)

## Construct the list with columns to read the input file
# It will depend on the DATA_FILES definition
if (length(DATA_FILES) == 1) {
	COLUMNS_TO_READ <- FIRST_COLUMN:OTHER_COLUMN # the range of columns
} else {
	COLUMNS_TO_READ <- c(FIRST_COLUMN, OTHER_COLUMN) # individual columns
}

## Set number of decimals for rounding
ROUND_dig <- 3 

## Convert experimental conditions into factors
EXP_FACTORS <-  factor(EXP_CONDITIONS)

## Frequency of every condition
COND_FREQ <- table(EXP_CONDITIONS)

## Convert contrast list into the required vector of contrasts
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

## Correlation parameters
# Set correlation method pearson or spearman
CORR_METHOD = "pearson"
# Set correlation threshold considering that r^2 = (0,75)^2 = 0,5625
R_MIN <- 0.75

## Set code-folding for Rmd
# my_codefolding <- ifelse(VERBOSE_MODE, "show", "hide")

# remove needless variables
rm(FIRST_COLUMN, OTHER_COLUMN, EXP_CONDITIONS)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MAIN EXECUTION USING MARKDOWN ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Set workind directory ####
setwd(WD)

## Launch rmarkdown report ####
cat("\n", "*** Creating markdown report ***", "\n")

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

message(paste(SOFT_NAME, VERSION_CODE, "report successfully fihished."))
cat("\n", "*** Report and results saved in the new folder ***", "\n")
message(WD)

T_total2 <- proc.time() - T00
message("\nReal time taken by the current run: ", round(T_total2[[3]]/60, digits = 3), " min")
print(T_total2)