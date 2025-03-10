# RSeqFlow

A comprehensive R markdown pipeline for processing RNA-Seq datasets from count files or tables in non-model organisms. It carries out the following steps:

1. Read/construct the expression table from RNA-seq mapping counts
2. Parametrisable quality control and gene filtering
3. Normalisation and _biologically relevant_ differential expression based on parametrisable _P_-value and fold change.
4. Correlation analyses for clustering
5. Co-expression networks, including hubs and subgraphs
6. Profiling outstanding (likely hub?) genes.

***

## Install

You will need a local copy of the GitHub _RSeqFlow_ repository on your machine. It can be done using git in the shell: 

```bash
$ git clone git@github.com:mgclaros/RSeqFlow.git 
```

Alternatively, you can go to <https://github.com/mgclaros/RSeqFlow/> and click on _Code_ button and then _Clone_, or select _Download ZIP_ or any other possibility you prefer. The cloned of unzipped directory `RSeqFlow` should be placed somewhere on your `$HOME` in Linux, macOS and Windows.

Then you can navigate inside _RSeqFlow_ using shell commands or window interface.


***

## Components

The GitHub repository and your local version will contain the following files and folders:

- `README.md`: this file
- `LICENSE`: details about the CC-BY license
- `configure_RSeqFlow.R`: a file containing all parameters necessary to execute _RSeqFolder_. This file can be located anywhere in your computer and is the only file that requires user intervention.
- `libraries_wf.R`: a file that loads, installs and updates the _RSeqFile_ required libraries.
- `functions_wf.R`: a file gathering all functions called within the code.
- `execute_wf.R`: a file that starts the execution of _RSeqFile_ using the parameters indicated in `configure_wf.R` and the markdown skeleton in `Report_RSeqFlow.Rmd`.
- `Refs_RSeqFlow.bib`: a text file in bib format containing all references cited in the final report.
- `Report_RSeqFlow.Rmd`: a markdown file where other Rmd fragments are incorporated.
- `Rmds`: a folder containing the Rmd fragments needed for the pipeline. 


***

## Prerequisites and dependencies

Minimum **RAM** required (depending on dataset size): 16 GB. Recommended RAM: 32 GB+

_RSeqFlow_ has been developed with **R 4.1.3** on mac and linux computers. Older R releases my fail due to library obsolescence.

**R packages/libraries** required are listed in `libraries_wf.R`. Do not worry for that since on the first _RSeqFlow_ run, it will check which libraries are not installed and will install them automatically. It may take for a very long time (up to 30 min, depending on the number of packages to be installed).

You should have some begginer experience with **bash** (Unix Shell) and R to execute this pipeline and transfer datasets to and from directories or computers.

You should understand the steps of a **canonical RNA-Seq analysis** (trimming, alignment, counting, etc.).


***


## Quick Start

_RSeqFlow_ can be launched using R console or RStudio in macOS, linux or Windows as

```r
> source("~/PATH_TO/configure_wf.R")
```

or using the terminal as

```bash
$ Rscript ~/PATH_TO/execute_wf.R ~/PATH_TO/aConfigFile.R 
```

If you try this just after downloading _RSeqFlow_, it will not work because you have to accommodate it to your computer environment. So, read carefully the next section before launching _RSeqFlow_ for the first time.


***


## Configuration

_RSeqFlow_ can be customised to your needs in the 'self-explained' `configure_wf.R` file. Open this file and you will see an initial segment entitled `DON'T TOUCH: CLEAN START` marking the three commands that you must not modify. They will clean memory variables before a _RSequFlow_ run.

After that, you will find all customisable parameters with a detailed explanation and exemplary values. In the following list, 

- **Compuslory** tag indicates that you have to customise the parameter to run _RSeqFlow_ for the first time or to read a specific experiment data.
- **Recommended** parameters will facilitate your analysis, but are not necessary to run _RSeqFlow_ in your computer.
- *Optional* parameters do not require customisation unless you detect a problem with your data. For example, you can have copies of the configure file with different set of optional parameters to compare the results.

Parameters customisable in the `configure_wf.R`:

- `PROJECT_NAME`: the project name to easily identify your work. **Recommended**
- `SOURCE_DIR`: the path to the directory of _RSeqFlow_. **Compulsory**
- `PKG_UPDATE`: if you want to update R packages before running _RSeqFlow_. *Optional*
- `VERBOSE_MODE`: `TRUE` if you want the complete report showing code chunks, or `FALSE` if you want to hide (fold) code chunks and skip complementary plots. *Optional*
- `DoCLUSTER_NETWORK`: `TRUE` if you want the complete analysis or `FALSE` if you want to calculate only differentially expressed genes and compare sample clustering using raw and normalised data. *Optional*
- `DATA_DIR`: the path to the directory containing your mapped count data. **Compulsory**
- `DATA_FILES`: one expression count table or several file names. **Compulsory**. 
    + When you indicate **one single count table**, you have to customise the number of 
        - `FIRST_COLUMN`: the first column in the table to read; Gene IDs is column 0. **Compulsory**
        - `LAST_COLUMN`: the last column to be read. **Compulsory**
    + When you indicate **several files with counts**, you have to customise the position of
        - `COUNTS_COLUM`: the column containing mapping counts. **Compulsory**
    + `CHARS_TO_REMOVE`: define the removable initial part of each file 'name', usually when data come from GEO database. *Optional*
- To customise the **experimental factors** that you want to analyse:
    + `CTRL` and `TREAT`: the minimum 2 factors (control and treatment, respectively) required for the analysis. **Compulsory**
    + `TREAT2` to `TREATn`: additional factor for multiple comparisons. The names can be changed by the user. *Optional*
- `EXP_CONDITIONS`: the correspondence between experimental factors and read data. **Compulsory**
- `C1, C2, C3...`:the contrast that you will analyse using the experimental factors expressed as a vector, where the first term will be for up-regulated genes and the second term the down-regulated ones (`fold change = first factor / second factor`). **Compulsory**
- `CONTRASTS`: the list of contrasts (`C1, C2, C3...`) previously defined that will be analysed. **Compulsory**
- Threshold values for several parameters (all *optional*)
    + `MIN_CPM`: minimal amount of counts per million to conserve a gene for the analysis.
    + `CV_MIN`: minimal coefficient of variance to filter by variability.
    + `FC`: minimal fold-change for differential expression analysis.
    + `P`: minimal _P_-value for significance in any statistical analysis.
    + `NODE_MAX`: the maximal number of genes to calculate correlations and clustering to avoid very long calculations.
    + `OPT_CLUST`: if you want to indicate the number of clusters that you want to obtain.
    + `MIN_GENES_PER_CLUSTER`: to avoid lowly populated clusters.
    + `MIN_KLEINBERG`: minimal value of the Kleinberg score to select outstanding (highly connected) genes.
- `MY_IDs`: a list of gene IDs that you are specially interested in from your data files. **Recommended**

As a result of this `configure_wf.R` file customisation, you can have as many copies of this file as you want (with the name you prefer) for different data or different parameters. These copies can be located wherever you want in your computer. 


***



## Compulsory customisation before the first run

### Define `SOURCE_DIR`

You can find `SOURCE_DIR` in the segment `PATH TO THE DIRECTORY CONTAINING THE SOURCE FILES`. This variable must contain the path on your computer to the `RSeqFlow` directory. This spares the use of the file path every time you use the pipeline and allows multiple configuration files wherever you want in your computer. 

**TIP**: Use, as in the original file, `~/` when your `RSeqFlow` directory is inside your `$HOME`, which is highly recommended. You can ask your computer for this path using the `pwd` bash command when you are within the _RSeqFow_ code folder using the `cd` command:

```bash
$ # Move into the RSeqFlow code folder:
$ cd ~/MyFiles/RScripts/RSeqFlow/ 
$ # ask for the complete path to this folder
$ pwd
```

that will render, for example,

~~~
/Users/myusername/MyFiles/RScripts/RSeqFlow/
~~~

or, in another computer,

~~~
/mnt/home/users/myusername/MyFiles/RScripts/RSeqFlow/
~~~


that you must incorporate within quotes as any of this three commands:

```r
SOURCE_DIR <- "/Users/myusername/MyFiles/RScripts/RSeqFlow/"
SOURCE_DIR <- "~/MyFiles/RScripts/RSeqFlow/"
SOURCE_DIR <- "/mnt/home/users/myusername/MyFiles/RScripts/RSeqFlow/"
```

> Do not forget the `/` at the end of the path.


### Define `DATA_DIR`

The variable `DATA_DIR` is in the configure segment entitled `PATH TO DATA-CONTAINING DIRECTORY`. Hence, it should contain **a path to the directory**, ~~not the files~~, where the expression data can be found. This will be the working directory, and all _RSeqFlow_ runs will save a new folder within it containing the corresponding results.

**TIP**: Refer to the `SOURCE_DIR` definition above to know how to obtain the required path. 

> Do not forget the `/` at the end of the path.


### Define `DATA_FILES`, `FIRST_COLUMN` and `OTHER_COLUMN`

These variables is in the configure segment entitled `LOAD YOUR EXPRESSION DATA`. The three are required to read the data, but mean different things depending on the way the data are presented.

#### Counts are in one single table

After mapping read libraries on the reference, most software enable the possibility to gather genes, samples and counts in one single file. For _RSeqFlow_, this table must be in **tsv format**, where:

* rows are genes, 
* columns are samples, 
* the values are the count of each gene in every sample.

A brief example of data table is the following:

GeneID | Sample_1.1 | Sample_1.2 | Sample_1.3 | Sample_2.1 | Sample_2.2 | ...
:---   | :---       | :---       | :---       | :---       | :---       | :---
Gene1  | 10         | 13         | 9          |  453       | 632        | ...
Gene2  | 100        | 87         | 99         |  0         | 2          | ...
...    | ...        | ...        | ...        | ...        | ...        | ... 

In this case the three variables are defined as follows:

* `DATA_FILES` must contain the **name of one single file** containing the table:

    ```r
    DATA_FILES <- "Counts-of-my-experiment.tsv"
    ```

* `FIRST_COLUMN` is column number of the **first sample** that will be read, taking into account that the first sample is $1$, that is, **Sample_1.1** in the example.

* `OTHER_COLUMN` is the column number of the **last sample** that will be read. For example, $5$ corresponds to **Sample_2.2** in the example.


#### Samples counts are in individual files

Other mapping software do not offer the possibility of gathering the mapping results in one single file. In this case, provided that each file is in tsv format and all of them have the same structure (it is usually the case). Let's see two different exemplary outputs.

1. The output of the pseudomapper _kallisto_ has the following structure:

    target_id	| length | eff_length	| est_counts | tpm
    :---      | :---   | :---       | :---       | :---
    Gene1     |	2016	 | 1982	      | 3	         | 25.7055
    Gene2     |	339	   | 305	      | 2	         | 111.362
    Gene3     |	1122	 | 1088	      | 3.83058	   | 59.792

2. The output for _Bowtie2_ is 

    ID	  | align_bowtie_sort_file.bam
    :---  | :---
    Gene1 |	254
    Gene2	| 92
    Gene3	| 1546


Hence, the three variables are defined as follows:

* `DATA_FILES` must contain a **vector of several file names** with the same structure (rows are genes and one of the columns must be the number of counts). Each file is expected to be the result of mapping one library on the reference. In this case, the tsv table is constructed by _RSeqFlow_ (and saved), the columns being in the same order as files in the vector.

    ```r
    DATA_FILES <- c("sample1.txt", "sample2.txt", "sample3.txt")
    ```

* `FIRST_COLUMN` is column number of the **gene IDs**, usually is the _first column_ of every file, so `FIRST_COLUMN <-` $1$

* `OTHER_COLUMN` is the column number of the **counts**. Do not use ~~TPMs~~ if provided. In the above examples, the value will be $4$ for the `est_counts` of _kallisto_ output and $2$ for the `align_bowtie_sort_file.bam` column in _Bowtie2_ output.


### Define experimental factors (`CTRL`, `TREAT`...)

The analysis requires at least two experimental factors, that must be assigned to variables `CTRL` (control) and `TREAT` (treatment) that you will find in the segment entitled `DEFINE YOUR FACTORS (EXPERIMENTAL CONDITIONS)`. Optionally, you can add more factors as required with the names that you want, although we suggest `TREAT2`, `TREAT3`, or even `CTRL2, CTRL3...` and so on in the search of clarity. Remember that these factors will be used to define the factor of columns and comparisons.

Examples of experimental factors:

```r
# Compulsory factors
CTRL <- "Wild type"
TREAT <- "My mutant"

# Optional factors
TREAT2 <- "Stressed wild type"
TREAT3 <- "NaCl 15 mM"
```

### Define `EXP_CONDITIONS` using the experimental factors

Once you defined the two or more experimental factors, you have to define the factor of each column (sample) in the variable `EXP_CONDITIONS` that you can find in the segment entitled `ASSIGN CONDITIONS TO SAMPLES (COLUMNS) IN DATA_FILES`.

If you have loaded data where the $3$ first columns are the controls (defined as `CTRL`), the next $3$ columns are one treatment (defined as `TREAT`), and the last $3$ columns correspond to another treatment (defined as `TREAT2`), you can define the `EXP_CONDITIONS` as the following vector:

```r
EXP_CONDITIONS <- c(CTRL, CTRL, CTRL, TREAT, TREAT, TREAT, TREAT2, TREAT2, TREAT2)
```

Imagine that you have only two replicates of controls and treatments in a paired fashion, so you want to place each control besides its treatment. In such a case, the definition will be

```r
EXP_CONDITIONS <- c(CTRL, TREAT, CTRL, TREAT)
```


### Define `CONTRASTS`

One of the main advantages de _RSeqFlow_ is that you can perform all **the comparisons** (contrasts) you want at once. Hence, you define the contrast as the consecutive variables `C1, C2, C3...` where the first condition/factor will be the first term of the fold-change logaritm and the second factor the second term:

```r
# both equations are equivalent
logFC <- log(first_factor/second_factor)
logFC <- log(first_factor) - log(second_factor)
```

> **Positive** `logFC` are genes up-regulated in the first factor.

> **Negative** `logFC` correspond to up-regulated genes in the second factor.

Considering the same three conditions indicated above, we can calculate the following three contrasts:

```r
# define any possible contrast
C1 <- c(TREAT, CTRL)
C2 <- c(TREAT2, TREAT)
C3 <- c(TREAT3, TREAT2)
```

Individual contrasts are then gathered in a list in the `CONTRASTS` variable:

```r
# the list of contrast that will be analised
CONTRASTS <- list(C1, C2, C3, C4)
```


***

## Input files

You need to customise the `configure_wf.Rmd` file with the variables indicated above. Data for your specific experiment are defined in the `DATA_FILES` variable. You have two possibilities (see above):

1. ONE TSV TABLE containing all genes (in rows) and all samples (in columns) with the raw counts. Specifi the single name in the `DATA_FILES` variable
2. MANY TSV TABLES containing the counts for each gene (rows) for one sample per file. You should pass as many files as samples. The file names must define a vector to be assigned to `DATA_FILES` variable


***


## Output files

Each execution of _RSeqFlow_ will create a separate folder close to your data, that is, within the `DATA_DIR` folder. The created folder will be called

> `RSeqFlow101_results_{DATETIME}`

where `{DATETIME}` is the date and time of the execution (for example, *2023-07-09_18.01.39*) to guarantee that a different folder is created on every execution and no overwriting will occur.

The folder will contain 

* a comprehensive **HTML report** called ` Report.html` explaining the analysis and plots (figures), analysis rationale, bibliography and explanation of each saved file.
* **many tables in `tsv` format** for correlations, clusters, normalisation, etc., now explained in alphabetical order (all files finishing with `{DATETIME}.tsv`, that has been removed for clarity):
    + `AllGenes_allContrast_TREAT-{P-value}_{FC}_`: Average expression, coefficient (LogFC), _t_ statistic, _P_ value, adjusted _P_ value, _F_ statistic, and DEG result for all genes in each of the contrasts using the _treat()_ method and the _P_ and _FC_ indicated in the filename by `{P-value}_{FC}`. 
    + `AllGenes_allContrast_eB_{P-value}_{FC}_`: Average expression, coefficient (LogFC), _t_ statistic, _P_ value, adjusted _P_ value, _F_ statistic, and DEG result for all genes in each of the contrasts using the _eBayes()_ method and the _P_ and _FC_ indicated in the filename by `{P-value}_{FC}`. 
    + `AllGenes_{CONTRAST}_TREAT_`: LogFC, average expression, _P_ value, and adjusted _P_ value, for all genes in the contrast indicated in `{CONTRAST}` using the _treat()_ method. 
    + `BestCorrelations_{METHOD}_{CLUSTER}-`: Correlation (_r_), _P_ value, and adjusted _P_ value for the pair of genes (Item1 and Item2) in each `{CLUSTER}` obtained with the indicated `{METHOD}`. 
    + `ClustersCTF-`: Averaged CTFs of the DEGs present in any cluster, indicating the number of the cluster and method where it appears.
    + `CTFnormalisedCPMs-`: Normalised CPMs for each gene (rows) in each sample replicate (columns) using the CTF algorithm.
    + `DEGs_{CONTRAST}_TREAT_{P-value}_{FC}_`: LogFC, average expression, _t_ statistic, _P_ value, and adjusted _P_-value, for all DEGs (rows) obtained for the `{CONTRAST}` using the _treat()_ method and the _P_ and _FC_ indicated in the filename by `{P-value}_{FC}`. 
    + `DEGs_{CONTRAST}_eB_{P-value}_{FC}_`: LogFC, average expression, _t_ statistic, _P_ value, adjusted _P_-value, and _B_ statistic for all DEGs (rows) for the `{CONTRAST}` using the _eBayes()_ method and the _P_ and _FC_ indicated in the filename by `{P-value}_{FC}`. 
    + `filteredData-`: Raw counts in all sample replicates (columns) for genes (rows) that presented a reliable expression.
    + `List_of_clusters-{DATETIME}.Rds`: R object containing all the information about clusters obtained with the three clustering methods AHC, _k_-means and MBC. It must be read with the R function _readRDS()_ to inspect or use its contents.
    + `normHomoscedCPM-`: TMM-normalised and homeoscedastic counts of reliable genes (rows) in all sample replicates (columns).
    + `OutstandingGenes-`: Highly linked genes in the different clusters that can be considered hub genes.
    + `TMMnormalisedCounts-`: Normalised counts for each gene (rows) in each sample replicate (columns) using the TMM algorithm.
    + `TMMnormalisedCPMs-`: Normalised CPMs for each gene (rows) in each sample replicate (columns) using the TMM algorithm.
    + `ubiquitousDEGs_`: List of genes that are DEGs in all the contrast performed in the analysis, including if it is up-regulated ($1$) or down-regulated ($-1$) in each contrast.



***

## Release History

Version | Date      | Comments
:---    | :---      | :---
0.9     | 9-Jun-22  | Initial release
1.0     | 21-Jul-22 | First stable release
1.01    | 7-Jul-23  | Small improvements avoiding unexpected crashes
1.02    | 3-Nov-23  | Minor display improvements, code debugging, more references and explanations
1.02b   | 6-Nov-23  | Two minor bugs in library load and removal of unused variables
1.03    | 18-Dec-24 | Gene filtering improved, minor bugs resolved
1.04    | 13-Jan-25 | Minor modifications in the report, changes in correlations and gene profiles
1.05    | 14-Jan-25 | Cosmetic modifications in the report and the code
1.1     | 10-Mar-25 | Improvements in graphics and HTML report. Clustering is now optional. Bugs fixed.
 

### v 1.1

- Cosmetic modifications in the code were introduced, mainly to avoid useless calculations and plots. More tabs have benn included to facilitate comparisons of different results or steps in the analysis.
- Cosmetic modifications were included in the HTML report. The most evident are:
    - Clustering results are now simplified and shown on tabs to facilitate the reading.
    - Heatmap colour palettes are unified.
    - Venn diagrams now fit in page in all report versions
    - Parameter `VERBOSE_MODE` makes code chunks to be shown (`TRUE`) or hidden (`FALSE`)
    - When model-based clustering only gives 1 cluster, _k_-means clusters are directly assigned to this analysis
    - Labelled communities in networks are more readable
- New parameter `DoCLUSTER_NETWORK` was included to stop execution after differential expression (`FALSE`) or do the complete script (`TRUE`)
- Heatmap within _Profiling gene clusters_ contains also the distribution of genes per cluster
- Plots of outstanding genes have been improved, showing genes in CTF-normalised and scaled counts. Additionally, internal controls were introduced to avoid plotting when no outstanding gene was selected.

### v 1.05

- Cosmetic modifications in the HTML report
- Cosmetic modification in the code

### v 1.04

- Minor modifications in the HTML report layout and the diplayed messages.
- Configuration parameter `OTHER_COLUMN` was renamed to `COUNTS_COLUM` when each library mapping is saved in individual files, or `LAST_COLUMN` when counts are as TSV file.
- Configuration parameter `LOG_EXPR` was removed to always use logarithms for correlations and CTF normalisation.
- Correlations are now based on the Spearman coefficient.
- Error bars in cluster profiles are based on the 95% confidence interval (CI95)


### v 1.03

- The stringency of `filterByExpr()` function can now be configured according to Thawng and Smith 2022 in the chunk `numRepFilt`.
- Maximum _y_ for density plots is established.
- General information about differential expression has been updated, including more references
- More parametrisations to avoid hardcoding variables
- Minor bugs making RSeqFlow to crash when some variables were empty.


### v 1.02

* A mew parameter `NODE_MAX` is required in the configuration file to avoid excessive calculations related to correlations and clustering with crowded networks.
* More theoretical details about the _P_-value misuse are given
* Raw data are always filtered using `edgeR::filterByExpr()` and then with the `MIN_CPM` threshold.
* When user-definded thresolds are `P > 0.05` and `FC > 1.5`, thresholds for `eBayes()` are set to `0.05` and `1.5`.
* MD plots using `treat()` function include the _P_ and _logFC_ thresholds used for `eBayes()` for comparative reasons.
* Networks with less than 2 nodes are not plotted.

***

## Citation

Please, reference this pipeline and its documentation as follows:

A. Bullones, A. J. Castro, E. Lima-Cabello, N. Fernandez-Pozo, R. Bautista, J. d. D. Alché, and M. G. Claros (2023) Transcriptomic insight into the pollen tube growth of _Olea europaea_ L. subsp. _europaea_ reveals reprogramming and pollen-specific genes including new transcription factors. ***Plants*** 12(16), 2894. [doi: 10.3390/plants12162894](https://doi.org/10.3390/plants12162894).


***

## License

![](https://licensebuttons.net/l/by/3.0/88x31.png)
[CC-BY](https://creativecommons.org/licenses/by/4.0/)

**Authors**: M. Gonzalo Claros, Amanda Bullones

Any concern, suggestion, bug or whatelse can be addressed to [Gonzalo Claros](mailto:claros@uma.es)
