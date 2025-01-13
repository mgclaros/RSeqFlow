# configure_wf -> RSeqFlow
# Gonzalo Claros
# 2025-01-13

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DON'T TOUCH: CLEAN START ####
#
rm(list=ls())    # clear variables in the work space
gc()             # garbage collection; returns free RAM to the operating system
graphics.off()   # shut down all open graphic devices
# ////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# GIVE A NAME TO YOUR PROJECT ####
#
# You should define a name to appear in the final report
#
# Example:
#   PROJECT_NAME = "Default template for RSeqFlow analyses"

PROJECT_NAME = "Olive pollen tube growth 0-1-3-6 h | TRANSCRIPTOME"
# //////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PATH TO THE DIRECTORY CONTAINING THE SOURCE FILES ####
#
# You should include here the path where the code can be found on your computer
#
# Example:
#   SOURCE_DIR = "~/usr/local/mycodingfiles/"
# A final "/" in path is compulsory

SOURCE_DIR = "~/Documents/MisScriptsR/RSeqFlow/"
# //////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# WILL BE PACKAGES UPDATED ####
#
# TRUE: old packages will be updated after installing the absent ones
# FALSE: only absent packages will be installed. No update of older ones

PKG_UPDATE = FALSE
# /////////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# WILL BE THE COMPLETE (VERBOSE) REPORT SAVED? ####
#
# TRUE: Necessary and complementary chunks will be obtained; code is shown
# FALSE: only necessary (relevant) chunks will be executed; code is hidden

VERBOSE_MODE = FALSE
# //////////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PATH TO DATA-CONTAINING DIRECTORY ####
#
# You should include here the path where this file is on your computer
# This file should be side-by-side with the input data
# Output files and folders will be created there
#
# Example:
#   DATA_DIR = "~/Documents/My_MA_data/this_experiment/"
# A final "/" in path is compulsory

DATA_DIR = "~/Documents/RNASeqData/olivo/Pollen_TR/"
# //////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# LOAD YOUR EXPRESSION DATA ####
#
# Files containing expression data must be in TSV format
# COMPULSORY: the first column in files must contain the gene IDs

# %%%%
# MAPPING COUNTS ARE IN SEPARATE FILES
# %%%%
# define every expression count file as a vector
# DATA_FILES = c("GSM1545538_purep53.txt",
               # "GSM1545539_JMS8-2.txt",
               # "GSM1545542_JMS8-5.txt",
               # "GSM1545535_10_6_5_11.txt", 
               # "GSM1545541_JMS8-4.txt",
               # "GSM1545545_JMS9-P8c.txt",
               # "GSM1545536_9_6_5_11.txt", 
			         # "GSM1545540_JMS8-3.txt", 
			         # "GSM1545544_JMS9-P7c.txt")

# Column with COUNTS, depending on the mapper used
# COUNTS_COLUMN = 3

# define the removable initial part of each file 'name'
CHARS_TO_REMOVE = 0 # the 11 first chars of all file names will be removed.


# %%%%
# MAPPING COUNTS ARE A SINGLE TABLE
# %%%%
# define the expression table filename
DATA_FILES = "pollen_picual_reord_TR3333.tsv"

# The FIRST COLUMN after the gene IDs colum that will be read; 1 is the one after gene IDs column
FIRST_COLUMN = 1

# The LAST COLUMN containing data
LAST_COLUMN = 12
# ///////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DEFINE YOUR FACTORS (EXPERIMENTAL CONDITIONS) ####
#
# define EVERY experimental condition to analyse. CTRL and TREAT are necessary
CTRL = "t0_MP"
TREAT = "t1_GP"

# Additional treatments or conditions
TREAT2 = "t3_GP"
TREAT3 = "t6_GP"
# ///////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ASSIGN CONDITIONS TO SAMPLES (COLUMNS) IN DATA_FILES ####
#
# Define a vector of factors corresponding to each file or column in DATA_FILES
# It must be within the c() function
#
# Example: 
# EXP_CONDITIONS = c(CTRL, CTRL, CTRL, TREAT, TREAT, TREAT, TREAT2, TREAT2, TREAT2)

EXP_CONDITIONS = c(rep(CTRL, 3), rep(TREAT, 3), rep(TREAT2, 3), rep(TREAT3, 3))
# ///////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DEFINE THE CONTRASTS ####
#
# Define the pairs of experimental conditions that you want to analyse
# One contrast per "number"; the second should be a kind of control
#
# Example:
# C1 = c(TREAT, CTRL)

C1 = c(TREAT, CTRL)
C2 = c(TREAT2, TREAT)
C3 = c(TREAT3, TREAT2)
C4 = c(TREAT3, TREAT)

# Now, convert these contrasts in list with list(). Do not forget any one!
CONTRASTS = list(C1, C2, C3, C4)
# ///////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# THRESHOLD FOR MINIMUM CPM PER GENE ####
#
# You must specify the CPM (counts per million) threshold for a 
# minimal count value for a gene in each treatment. Margin: 0.5-5
#
# Example:
# MIN_CPM = 0.5

MIN_CPM = 1
# ///////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MINIMUM COEFFICIENT OF CORRELATION (CV) ####
#
# You must specify the CV threshold for a considering a gene as 
# highly variable among treatments. Margin: 0.1 or higher
#
# Example:
# CV_MIN = 0.10

CV_MIN = 0.20
# ///////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# THRESHOLD FOR FOLD-CHANGE ###
#
# You must specify the fold-change threshold (in absolute value) for a 
# spot signal to be considered as differentially expressed
# Using treat(), the FC should be low (2 is high)
#
# Example:
#   FC = 2

FC = 1.2
# /////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%
# THRESHOLD FOR P-VALUE ####
#
# You must specify the P-value threshold for a spot signal to be considered as
# significative. When FDR is used, P < 0.1 (FDR < 10%) can be appropriate
#
# Example:
#   P = 0.05

P = 0.1
# //////////////////////////


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MAXIMAL NUMBER OF DEGs FOR CORRELATION AND CLUSTERING ####
#
# An excessive number of DEGs can take too much time to calculate
# correlation and networking parameters. You can determine here the
# maximal number of genes you want to correlate and clusterise. 
# Beyond 700 genes, it may take hours
#
# Example:
#   NODE_MAX = 250

NODE_MAX = 350
# ////////////////////////////////////////////////////////


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# OPTIMAL NUMBER OF GENE CLUSTERS ####
#
# You CAN specify the number of clusters for genes as an integer
# If you want that value to be automatically calculated, set it to 0
#
# Example:
#   OPT_CLUST = 4

OPT_CLUST = 0
# ////////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# OPTIMAL NUMBER OF GENE CLUSTERS ####
#
# You CAN specify minimal number of genes in a cluster, which is 20
# by default in the corresponding function
#
# Example:
#   MIN_GENES_PER_CLUSTER = 20

MIN_GENES_PER_CLUSTER = 10
# ///////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MINIMAL KLEINBERG SCORE ####
#
# You CAN specify minimal Kleinberg score to qualify genes as putative hubs
# when analysing networks. This score ranges from 0 (bad) to 1 (maximum)
#
# Example:
#   MIN_KLEINBERG = 0.95

MIN_KLEINBERG = 0.90
# ////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# USER SELECTED IDs ####
#
# You may want to see the behaviour or certaing genes. In this case, uncomment
# the MY_IDs line and add all IDs you are interested in.
#

# MY_IDs = c("Ciclev10013356m.g", "Ciclev10013262m.g", "Ciclev10022710m.g", "Ciclev10011381m.g", "Ciclev10012375m.g", "Ciclev10012384m.g", "Ciclev10013485m.g", "Ciclev10013337m.g", "Ciclev10013821m.g")
# //////////////////////////




# %%%%%%%%%%%%%%%%%%%%%%%%%%%
# END CONFIGURATION FILE ####
# %%%%%%%%%%%%%%%%%%%%%%%%%%%

# %%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%
# DO NOT TOUCH THE FOLLOWING
# %%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%

# Determine interactivity to know if 'execute_RNAseqHAB.R' has to be sourced
INTERACTIVE_SESSION <- interactive()
if (INTERACTIVE_SESSION) {
	message("Interactive run: 'execute_wf.R' will be sourced")
	fileToSource <- paste0(SOURCE_DIR, "execute_wf.R")
	# load the main executable R file
    source(fileToSource)
} else {
	message("Run will stop unless you launched it as:\n")
	message("    Rscript execute_wf.R configure_wf.R\n")
}