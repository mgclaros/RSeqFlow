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


## Prerequisites and dependencies

Minimum **RAM** required (depending on dataset size): 16 GB. Recommended RAM: 32 GB+

_RSeqFlow_ has been developed with **R 4.1.3** on mac and linux computers. Older R releases my fail due to library obsolescence.

**R packages/libraries** required are listed in `libraries_wf.R`. Do not worry for that since on the first _RSeqFlow_ run, it will check which libraries are not installed and will install them automatically. It may take for a very long time (up to 30 min, depending on the number of packages to be installed).

You should have some begginer experience with **bash** (Unix Shell) and R to execute this pipeline and transfer datasets to and from directories or computers.

You should understand the steps of a **canonical RNA-Seq analysis** (trimming, alignment, counting, etc.).


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


## Configuration of RSeqFlow

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

## Compulsory customisation before the first run

### Define SOURCE_DIR

You can find `SOURCE_DIR` in the segment `PATH TO THE DIRECTORY CONTAINING THE SOURCE FILES`. This variable must contain the path on your computer to the `RSeqFlow` directory. This spares the use of the file path every time you use the pipeline and allows multiple configuration files wherever you want in your computer. 

**TIP**: Use, as in the original file, `~/` when your `RSeqFlow` directory is inside your `$HOME`, which is highly recommended. You can ask your computer for this path using the `pwd` bash command when you are within the _RSeqFow_ code folder using the `cd` command:

~~~
# Move into the RSeqFlow code folder:
cd ~/MyFiles/RScripts/RSeqFlow/ 
# ask for the complete path to this folder
pwd
~~~

that will render, for example,

~~~
/Users/myusername/MyFiles/RScripts/RSeqFlow/
~~~

or, in another computer,

~~~
/mnt/home/users/myusername/MyFiles/RScripts/RSeqFlow/
~~~


that you must incorporate within quotes as any of this three commands:

`SOURCE_DIR = "/Users/myusername/MyFiles/RScripts/RSeqFlow/"`

`SOURCE_DIR = "~/MyFiles/RScripts/RSeqFlow/"`

`SOURCE_DIR = "/mnt/home/users/myusername/MyFiles/RScripts/RSeqFlow/"`

> Do not forget the `/` at the end of the path.


#### Define DATA_DIR

asassas

> Do not forget the `/` at the end of the path.



#### Define PROJECT_NAME

You are invited to give a project name to your run to appear at the begining of the report. This name is stored in the configuration variable `PROJECT_NAME`.


## Pipeline components

The GitHub repository and your local version will contain the following files and folders:

**Instrucciones para un buen readme** <https://remarkablemark.org/blog/2021/01/03/how-to-write-a-great-readme/>


**FALTA ESCRIBIRLO** 

- Command-line interface: `bin/workflow.sh`
- Text logger of STDOUT/STDERR: `bin/logger.sh`
- Read QC checks: `bin/fastqc.sh`
- Read Trimming and filtering: `bin/prinseq.sh`
- Mapping reference preparation:`bin/rsem_ref.sh`
- Read mapping and TPM calculation: `bin/rsem_tpm.sh`


* config/samples.tsv: a file containing sample names and the paths to the forward and eventually reverse reads (if paired-end). This file has to be adapted to your sample names before running the pipeline.
* config/refs/: a folder containing
* .fastq/: a (hidden) folder containing subsetted paired-end fastq files used to test locally the pipeline. Generated using Seqtk: seqtk sample -s100 <inputfile> 250000 > <output file> This folder should contain the fastq of the paired-end RNA-seq data, you want to run.
* envs/: a folder containing the environments needed for the pipeline:




### Input files

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





***

## Release History

Version | Date      | Comments
:---    | :---      | :---
0.9     | 9-Jun-22  | Initial release
1.0     | 21-Jul-22 | First stable release
... | ... | ...

***

## Citation

You can reference this pipeline and its documentation as follows:

COLOCAR REFERENCIA CUANDO LA HAYA


***

## License

![](https://licensebuttons.net/l/by/3.0/88x31.png)
[CC-BY](https://creativecommons.org/licenses/by/4.0/)

**Authors**: M. Gonzalo Claros, Amanda Bullones, Noé Fernández-Pozo

Any concern, suggestion, bug or whatelse can be addressed to [Gonzalo Claros](mailto:claros@uma.es)
