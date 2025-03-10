# functions_wf -> RSeqFlow
# Gonzalo Claros
# 2025-02-22


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DETERMINING THE COMPUTER ####

GetComputer <- function() {
  # .Platform and R.version are defined by the system
  if (grepl("linux", R.version$platform)) {
    comput <- "Linux"
  } else if (grepl("pc", R.version$platform)) { 
    comput <- "Windows"
  } else if (grepl("w64", R.version$platform)) { 
    comput <- "Windows64"
  } else if (grepl("apple", R.version$platform)) {
    comput <- "Mac" 
  } else {
    comput <- "Other" 
  }
  return(paste0(comput, " - ", .Platform$OS.type))
}
# /////////////////////////////


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# WORKING DIRECTORY DEFINITION ####

CreateDir <- function(adir     = DATA_DIR,
                      aname    = SOFT_NAME,
                      aversion = VERSION_CODE,
                      adate    = HOY) {
  name.wd <- paste0(adir, aname, aversion, "_results_", adate, "/")
  
  if (file.exists(name.wd)){                # ¿existe el directorio ya?
    msg <- paste0("Directory '", name.wd, "' already exists")
  } else if (dir.create(name.wd)) {         # ¿ha creado el directorio con éxito?
    msg <- paste0("Directory '", name.wd, "' created")
  } else {
    # if the directory cannot be created, give an error message and stop
    msg <- paste0(msg, "   Directory ", name.wd ," cannot be created in")
    msg <- paste0(msg, "   ", adir, "\n")
    stop("ERROR: \n", msg, call = FALSE)
  }
  message(msg)	
  return(name.wd)
}
# /////////////////////////////////


# %%%%%%%%%%%%%%%%%%%%%%%%
# LOAD EXPRESSION DATA ####

LoadExpressionData <- function (files      = DATA_FILES,
                                dataDir    = DATA_DIR,
                                theFactors = EXP_FACTORS,
                                colsToRead = COLUMNS_TO_READ,
                                chars2rm   = CHARS_TO_REMOVE) {
  if (length(files) == 1) {
    # only one file defined, therefore, is a complete counts table
    countsTable <- read.delim(paste0(dataDir, files),    # datafile path
                              row.names = 1,             # IDs must be at the first column
                              quote = "")[, colsToRead]  # range of columns to be read
    msg <- "a **single data table**"
    counts_obj <- DGEList(counts = countsTable,          # convert to DGEList object
                          group = theFactors) 
  } else {
    # several files defined to construct the counts table
    counts_obj <- readDGE(files,                         # read files and convert to DGEList object
                          path = dataDir, 
                          columns = colsToRead)          # columns with IDs and counts
    msg <- "**several data files**"
    # add factor information to the DGEList object for differential expression
    counts_obj$samples$group <- theFactors
    
    # trim long names to let only the significant part
    sample_names <- colnames(counts_obj)
    new_names <- substring(sample_names, chars2rm + 1, nchar(sample_names))
    colnames(counts_obj) <- new_names
  }
  
  message("Counts from ", msg, " were read. The corresponding DGEList object was created")
  return(counts_obj)
}
# //////////////////////////////////


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# SAVE DATA IN TSV FORMAT ####

SaveTSV <- function(theDataTable, 
                    dataText,
                    adir = WD,
                    adate = HOY,
                    colN = NA,
                    rowN = TRUE) {
  # create the file name to save in working directory
  fileName <- paste0(adir, dataText, adate, ".tsv" )
  
  # use col.names = NA to have an empty ID for row.names
  write.table(theDataTable, 
              file = fileName, 
              sep = "\t", 
              quote = FALSE,
              col.names = colN,
              row.names = rowN)
  
  return(fileName)
}
# /////////////////////////////////////




# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ALWAYS HAVE A TRUE AND FALSE COLUMNS ####
# input: a contingency table with colums of TRUE and/or FALSE

Avoid_0_counts <- function(aTable) {
  column_names <- names(aTable)                   # get column names
  if (length(column_names) == 1) {                # modify when only 1 column is present
    expected_names <- c("TRUE", "FALSE")
    # get the name of the lacking column
    lack_name <- expected_names[!(expected_names %in% column_names)]
    aTable[[lack_name]] <- 0                      # set the value to 0
  }
  return(aTable)                                  # return the new table
}
# /////////////////////////////////////




# %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# CUSTOMISED PCA PLOT ####

PlotMyPCA <- function(datatable, 
                      titleText, 
                      thisScale = TRUE,  # raw data must set this to FALSE due to zeros or constant  vaules 
                      factorColors = EXP_COLORS) {
  pca <- prcomp(t(datatable), scale = thisScale, center = TRUE)
  # scale = TRUE makes each of the variables in datatable to have a mean of 0 
  # and a standard deviation of 1 before calculating the principal component
  pc_comp <- summary(pca)$importance # to see the importance of principal components
  pc1_contrib <- round(pc_comp[3, 1] * 100, digits = 1) 
  pc2_contrib <- round((pc_comp[3, 2] - pc_comp[3, 1]) * 100, digits = 1)
  
  plot(pca$x[, 1], pca$x[, 2], 
       pch = ".", 
       xlab = paste0(colnames(pc_comp)[1], " (", pc1_contrib, " %)"), 
       ylab = paste0(colnames(pc_comp)[2], " (", pc2_contrib, " %)"),
       main = titleText)
  text(pca$x[, 1], pca$x[, 2], 
       col = factorColors, 
       labels = colnames(datatable))
  
  return(list(PCA = pca, CumulativeProp = pc_comp))
}
# ////////////////////////////////




# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PLOT GENE DENSITY DISTRIBUTION ####

PlotGeneDensity <- function(obj, 
                            thecutoff, 
                            atext, 
                            thenames = COL_NAMES) {
  nsamples <- ncol(obj)
  max_y <- round(max(density(obj)$y),    # obtain the maximum of density in the object
                 digits = ROUND_dig)
  col <- brewer.pal(nsamples, "Paired")
  plot(density(obj[, 1]), 
       col = col[1], 
       lwd = 2, 
       ylim = c(0, max_y),
       las = 2, 
       main = atext, 
       xlab = "Log-cpm")
  abline(v = 0, lty = 3)                 # dotted line in CPM = 1
  abline(v = thecutoff, lty = 2)         # dashed line for most filtered off genes
  for (i in 2:nsamples) {
    den <- density(obj[, i])
    lines(den$x, den$y, col = col[i], lwd = 2)
  }
  legend("topright", thenames, text.col = col, bty = "n")
}
# //////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# CALCULATE COEFFICIENTS OF GENE VARIABILITY ####

calculaVars <- function(expData){
  # Convert expData to a data.frame
  tdata <- as.data.frame(expData)
  ini_samples <- ncol(tdata) # columnas con las que calcular los índices
  
  # Obtaining the mean of the expression values
  tdata$mean <- rowMeans(tdata, na.rm = TRUE)
  
  # Obtaining the dispersion D to each row
  Disp <- function(x){var(x, na.rm = TRUE)/abs(mean(x, na.rm = TRUE))}
  # Apply the function to the expression matrix
  tdata$d <- apply(tdata[, 1:ini_samples], 1, Disp)
  
  # Obtaining the coefficient of variation CV to each row
  CV <- function(x){sd(x, na.rm = TRUE)/abs(mean(x, na.rm = TRUE))}
  # Apply the function to the expression matrix
  tdata$cv <- apply(tdata[, 1:ini_samples], 1, CV)
  
  # Obtaining the coefficient of dispersion COD to each row
  COD <- function(x){mad(x, na.rm = TRUE)/abs(median(x, na.rm = TRUE))}
  # Apply the function to the expression matrix
  tdata$cod <- apply(tdata[, 1:ini_samples], 1, COD)
  
  # Return the expression matrix with the mean, the CV and the COD
  return(tdata)
}
# //////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# CALCULATING AGGLOMERATIVE COEF WITH SEVERAL METHODS ####

CalcAgglomCoef <- function(x, df) {
  # agnes is defined in cluster library
  # return only aggl. coef (ac) for each method
  ac <- agnes(df, method = x)$ac
  return(ac)
}
# //////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# FINDING THE FIRST MAXIMUM IN A VECTOR ####

ExtractFirstMax <- function (aVector) {
  l <- length(aVector) - 1
  i <- 2
  while(aVector[i] < aVector[i + 1]) {
    if (i < l) {
      i <- i + 1
    } else {
      i <- i + 1 # return the last value
      break
    }
  }
  return(i)
}
# //////////////////////////////////


# %%%%%%%%%%%%%%%%%%
# VENN DIAGRAMS ####

DoVennColoured <- function(vector_list,
                           aTitle = "Venn diagram") {
  venn_IDs <- venn::venn(vector_list,
                         zcolor = "style", 
                         ellipse = TRUE, 
                         ilcs = 1, 
                         sncs = 1.2, 
                         box = FALSE,
                         main = aTitle)
  return(venn_IDs)  # to see attr(venn_IDs, "intersections")
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# matplot OF CLUSTERS ####
MatPlot4Clusters <- function(m, 
                             mainTitle = "Gene profiles",
                             myCols = brewer.pal(12, "Set3")) {
  # create a place at rigth (8) for the legend outside the graph
  # structure of mar = c(bottom, left, top, right)
  par(mar = c(4, 4, 3, 8), xpd = TRUE) 
  # matrix plot
  matplot(m,               # transpose to put columns as x an gene expression as y
          main = mainTitle,
          type = "b", 
          las = 2,         # all labels perpendicular to axes
          pch = 0:25,      # point characters (symbols, up to 25 different)
          col = myCols,    # colours
          lty = 1:ncol(m), # line types in the plot
          lwd = 2,         # line width
          ylab = "Expression level (median)",
          xlab = "Experimental condition",
          xaxt = "n")      # remove x labels
  # define new x labels
  axis(1,                    # below
       at = 1:nrow(m),
       labels = rownames(m),
       las = 2,
       cex.axis = 0.8)       # = 1?
  # legend outside the plot
  legend("topright", 
         inset = c(-0.3, 0), # legend outside the plot
         col = myCols,
         # legend = colnames(m),  
         legend = paste("Clust", 1:ncol(m)),
         lty = 1:ncol(m), 
         lwd = 2,
         bty= "o", 
         pch = 0:25,
         cex = 0.7)
}
# //////////////////////////////////



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# GGmatplot FOR GENE PROFILES ####
PlotGeneProfiles <- function(m, 
                             aTitle = "Profiles",
                             y_label = "Scaled expression values") {
  df <- data.frame(m) # colnames are the gene names
  # convert rownames in numbers by adding a new first column
  new_x <- 1:nrow(df)
  samples_names <- rownames(df) # save sample names for further plot
  df <- cbind(new_x, df)
  # reshape wide data.frame to a long format for ggplot
  df2 <- melt(df,  id.vars = 'new_x', variable.name = 'GeneID')
  new_col_names <- colnames(df2)
  ggplot(df2, aes(x = new_x, y = value)) + # equivalent to aes(x=df2[, 1], y=df2[, 3])
    # colour lines per GeneID
    # geom_line(aes(colour = GeneID)) +
    geom_line(aes(colour = GeneID, group = GeneID), linewidth = 0.5, alpha = 0.3) + # GeneID is df[, 2]
    # add ranges and the trend line in orange
    geom_smooth(method = 'loess', formula = y ~ x, linewidth = 2, se = TRUE, color = "orange") +
    # change x continuous labels for sample names
    scale_x_continuous(name = "Samples", breaks = 1:length(samples_names), labels = samples_names) + 
    # change legend and Y title
    scale_y_continuous(name = y_label) +
    # add the title
    ggtitle(aTitle) +
    theme_bw() + 
    # change orientation and size of sample names, title, background, legend, axis...
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
          legend.position = "none",
          # panel.border = element_rect(fill = NA, color = "black"),
          # panel.grid = element_line(color = "lightgray", size = 0.5),
          # panel.background = element_rect(fill = "white"),
          plot.title = element_text(lineheight = 0.8, face = "bold"))
}
# //////////////////////////////////


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# matplot PROFILES OF SELECTED GENES ####
SelectedGeneProfilePlots <- function(m, 
                                     aTitle = "Profiles of selected genes",
                                     y_label = "Scaled expression values") {
  df <- data.frame(m) # colnames are the gene names
  # convert rownames in numbers by adding a new first column
  new_x <- 1:nrow(df)
  samples_names <- rownames(df) # save sample names for further plot
  df <- cbind(new_x, df)
  # reshape wide data.frame to a long format for ggplot
  df2 <- melt(df,  id.vars = 'new_x', variable.name = 'GeneID')
  new_col_names <- colnames(df2)
  staticPlot <- ggplot(df2, aes(x = new_x, y = value)) + # equivalent to aes(x=df2[, 1], y=df2[, 3])
    # colour lines per gene
    geom_line(aes(colour = GeneID, group = GeneID), linewidth = 0.9, alpha = 0.3) + # GeneID is df[, 2]
    # resize points with the same colour than lines
    geom_point(size = 1.25, aes(colour = GeneID)) +
    # change x continuous labels for sample names
    scale_x_continuous(name = "Samples", breaks = 1:length(samples_names), labels = samples_names) + 
    # change legend and Y title
    scale_y_continuous(name = y_label) +
    # add the title
    ggtitle(aTitle) +
    theme_linedraw() + 
    # change orientation and size of sample names, title, background, legend, axis...
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
          legend.position = "none",
          # legend.text = element_text(colour="black", size = 8),
          # legend.key.size = unit(4, units = "mm"),
          # panel.border = element_rect(fill = NA, color = "black"),
          panel.grid = element_line(color = "lightgray", linewidth = 0.5),
          # panel.background = element_rect(fill = "white"),
          plot.title = element_text(lineheight = 0.8, face = "bold", size = 12, colour = "darkgreen"))
  ggplotly(staticPlot)
}
# //////////////////////////////////
