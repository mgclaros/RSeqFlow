# RSeqFlow

A comprehensive pipeline for processing RNA-Seq datasets from count files or tables in non-model organisms. 

The pipeline carries out the following steps:

1. Read/construct a count table from RNA-seq mappings
2. Quality control and gene filtering
3. Normalisation and _biologically relevant_ differential expression
4. Correlation analyses for clustering
5. Co-expression networks, including hubs and subgraphs
6. Outstanding gene profiles

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
- `configure_wf.R`: a file containing all parameters necessary to execute _RSeqFolder_. This file can be located anywhere in your computer and is the only file that requires user intervention.
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

* **Compuslory** tag indicates that you have to customise the parameter to run _RSeqFlow_ for the first time or to read a specific experiment data.
* **Recommended** parameters will facilitate your analysis, but are not necessary to run _RSeqFlow_ in your computer.
* *Optional* parameters do not require customisation unless you detect a problem with your data. For example, you can have copies of the configure file with different set of optional parameters to compare the results.

Parameters customisable in the `configure_wf.R`:

* `PROJECT_NAME`: the project name to easily identify your work. **Recommended**
* `SOURCE_DIR`: the path to the directory of _RSeqFlow_. **Compulsory**
* `PKG_UPDATE`: if you want to update R packages before running _RSeqFlow_. *Optional*
* `VERBOSE_MODE`: if you want a verbose or clean report. *Optional*
* `DATA_DIR`: the path to the directory containing your mapped count data. **Compulsory**
* Variables to read your files correctly:
  + `DATA_FILES`: expression count table or file names. **Compulsory**
  + `FIRST_COLUMN` and `OTHER_COLUMN`: define the columns in the table or the files that contain the counts. **Compulsory**
  + `CHARS_TO_REMOVE`: define the removable initial part of each file 'name', usually when data come from GEO database. *Optional*
* Experimental factors that you want to analyse:
  + `CTRL` and `TREAT`: the minimum 2 factors (control and treatment, respectively) required for the analysis. **Compulsory**
  + `TREAT2` to `TREATn`: additional factor for multiple comparisons. The names can be changed by the user. *Optional*
* `EXP_CONDITIONS`: the correspondence between experimental factors and read data. **Compulsory**
* `C1, C2, C3...`:the contrast that you will analyse using the experimental factors expressed as a vector, where the first term will be for up-regulated genes and the second term the down-regulated ones (`fold change = first factor / second factor`). **Compulsory**
* `CONTRASTS`: the list of contrasts (`C1, C2, C3...`) previously defined that will be analysed. **Compulsory**
* Threshold values for several parameters (all *optional*)
  + `MIN_CPM`: minimal amount of counts per million to conserve a gene for the analysis.
  + `LOG_EXPR`: to scale counts or log-counts to measure gene variability. 
  + `CV_MIN`: minimal coefficient of variance to filter by variability.
  + `FC`: minimal fold-change for differential expression analysis.
  + `P`: minimal _P_-value for significance in any statistical analysis.
  + `NODE_MAX`: the maximal number of genes to calculate correlations and clustering to avoid very long calculations.
  + `OPT_CLUST`: if you want to indicate the number of clusters that you want to obtain.
  + `MIN_GENES_PER_CLUSTER`: to avoid lowly populated clusters.
  + `MIN_KLEINBERG`: minimal value of the Kleinberg score to select outstanding (highly connected) genes.
* `MY_IDs`: a list of gene IDs that you are specially interested in from your data files. **Recommended**

As a result of this `configure_wf.R` file customisation, you can have as many copies of this file as you want (with the name you prefer) for different data or different parameters. These copies can be located wherever you want in your computer. 


***



## Compulsory customisation before the first run

### Define SOURCE_DIR

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


### Define DATA_DIR

The variable `DATA_DIR` is in the configure segment entitled `PATH TO DATA-CONTAINING DIRECTORY`. Hence, it should contain **a path to the directory**, ~~not the files~~, where the expression data can be found. This will be the working directory, and all _RSeqFlow_ runs will save a new folder within it containing the corresponding results.

**TIP**: Refer to the `SOURCE_DIR` definition above to know how to obtain the required path. 

> Do not forget the `/` at the end of the path.


### Define DATA_FILES, FIRST_COLUMN and OTHER_COLUMN

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

* `FIRST_COLUMN` is column number of the **first sample** that will be read, taking into account that the first sample is `1` ('Sample_1.1' in the example).

* `OTHER_COLUMN` is the column number of the **last sample** that will be read. For example, `4` correspond to 'Sample_2.1' in the example.


#### Samples are in individual files

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

* `FIRST_COLUMN` is column number of the **gene IDs**, usually is the _first column_ of every file, so `FIRST_COLUMN <- 1`

* `OTHER_COLUMN` is the column number of the **counts**. Do not use ~~TPMs~~ if provided. In the above examples, the value will be `3` for the `est_counts` of _kallisto_ output and `1` for the `align_bowtie_sort_file.bam` column in _Bowtie2_ output.


### Define experimental factors (CTRL, TREAT...) and assing them to samples (EXP_CONDITIONS)

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

Once you defined the experimental factor, you have to define the factor of each column (sample) in the variable `EXP_CONDITIONS` that you can find in the segment entitled `ASSIGN CONDITIONS TO SAMPLES (COLUMNS) IN DATA_FILES`.

If you have loaded data where the 3 first columns are the controls (defined as `CTRL`), the next 3 columns are one treatment (defined as `TREAT`), and the last 3 columns correspond to another treatment (defined as `TREAT2`), you can define the `EXP_CONDITIONS` as the following vector:

```r
EXP_CONDITIONS <- c(CTRL, CTRL, CTRL, TREAT, TREAT, TREAT, TREAT2, TREAT2, TREAT2)
````


### Define CONTRASTS

One of the main advantages de _RSeqFlow_ is that you can perform all the comparisons (contrasts) you want at once. Hence, you define the constrast as the consecutive variables `C1, C2, C3...` where the first condition/factor will be the first term of the fold-change logaritm and the second factor the second term:

```r
logFC <- log(First-factor/Second-factor)
logFC <- log(First-factor) - log(Second-factor)
```

so that positive `logFC` are genes up-regulated in the first factor, and negative `logFC` correspond to up-regulated genes in the second factor.

Considering the same three conditions indicated above, we can calculate the following contrasts:

```r
C1 <- c(TREAT, CTRL)
C2 <- c(TREAT2, TREAT)
C3 <- c(TREAT3, TREAT2)
```

These individual contrasts are then gathered in a list in the `CONTRASTS` variable:

```r
CONTRASTS <- list(C1, C2, C3, C4)
```


***

## Input files

**FALTA ESCRIBIRLO** 

1. FASTA: Genome Assembly of your choice as a single FASTA file. <br/>
2. GTF: Gene Annotation File in GTF format
3. TX2GENE: A Transcript ID to Gene ID Conversion table for RSEM. IMPORTANT: Has to match IDs in your GTF file.

* RNA-seq fastq files as listed in the config/samples.tsv file. Specify a sample name (e.g. “Sample_A”) in the sample column and the paths to the forward read (fq1) and to the reverse read (fq2). If you have single-end reads, leave the fq2 column empty.
* A genomic reference in FASTA format. For instance, a fasta file containing the 12 chromosomes of tomato (Solanum lycopersicum).
* A genome annotation file in the `GTF format <https://useast.ensembl.org/info/website/upload/gff.html>`__. You can convert a GFF annotation file format into GTF with the gffread program from Cufflinks: gffread my.gff3 -T -o my.gtf. :warning: for featureCounts to work, the feature in the GTF file should be exon while the meta-feature has to be transcript_id.



## Usage
Explain how to run and use the project. This is a good place to describe what each script, class, function, or option does. Further examples can also beneficial.

1. Create a Tab-delimited file with SRA Accession IDs in first column <br/>
2. Specify your inputs in Config.sh File <br/>
3. Navigate to the RNA-Seq-Pipeline directory 
4. Run the following command: <br/>
```bash
./Run.sh
```




##### Steps:
  1. Lo primoer
  2. lo segundo
  
```sh
$ docker image pull dceoy/rna-seq-pipeline
```

```r
> do things
```


## Output files

- A table of raw counts called raw_counts.txt: this table can be used to perform a differential gene expression analysis with DESeq2.
- A table of DESeq2-normalised counts called scaled_counts.tsv: this table can be used to perform an Exploratory Data Analysis with a PCA, heatmaps, sample clustering, etc.
- fastp QC reports: one per fastq file.
- bam files: one per fastq file (or pair of fastq files).

Ejemplo: <https://github.com/UMCUGenetics/RNASeq>


## Usage

##### Example: Human RNA-seq

1.Open a Shell window and type: singularity run docker://bleekerlab/snakemake_rnaseq:4.7.12 to retrieve a Docker image that includes the pipeline required software (Snakemake and conda and many others).
2. Run the pipeline on your system with singularity run snakemake_rnaseq_4.7.12.sif and add any options for snakemake (-n, --cores 10) etc. The directory where the sif file is stored will automatically be mapped to /home/snakemake. Results will be written to a folder named $PWD/results/ (you can change results to something you like in the result_dir parameter of the config.yaml).

3.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/rna-seq-pipeline.git
    $ cd rna-seq-pipeline
    ```

2.  Download reference genome data in `input/ref`.

    ```sh
    $ mkdir -p input/ref
    $ ./misc/download_GRCh38.sh input/ref
    ```

    `misc/download_GRCh38.sh` requires `wget`.

3.  Put paired-end FASTQ data in `input/fq`.

    - File name format:
      - R1: `<sample_name>.R1.fastq.gz`
      - R2: `<sample_name>.R2.fastq.gz`

    ```sh
    $ mkdir input/fq
    $ cp /path/to/fastq/*.R[12].fastq.gz input/fq
    ```

4.  Execute the pipeline.

    ```sh
    $ mkdir output
    $ docker-compose up
    ```

    Execution using custom reference data:

    ```sh
    $ mkdir output
    $ docker-compose run --rm rna-seq-pipeline \
        --qc \
        --ref-gtf=/path/to/<ref>.gtf.gz \
        --ref-fna=/path/to/<ref>.fna.gz \
        --in-dir=input/fq \
        --out-dir=output \
        --seed=0
    ```

    Run `docker-compose run --rm rna-seq-pipeline --help` for more details of options.

**Instrucciones para un buen readme** <https://remarkablemark.org/blog/2021/01/03/how-to-write-a-great-readme/>





***

## Release History

Version | Date      | Comments
:---    | :---      | :---
0.9     | 9-Jun-22  | Initial release
1.0     | 21-Jul-22 | First stable release
1.01    | 07-Jul-23 | Small improvements avoiding unexpected crashes
... | ... | ...

***

## Citation

You can reference this pipeline and its documentation as follows:

COLOCAR REFERENCIA CUANDO LA HAYA


***

## License

![](https://licensebuttons.net/l/by/3.0/88x31.png)
[CC-BY](https://creativecommons.org/licenses/by/4.0/)

**Authors**: M. Gonzalo Claros, Amanda Bullones

Any concern, suggestion, bug or whatelse can be addressed to [Gonzalo Claros](mailto:claros@uma.es)
