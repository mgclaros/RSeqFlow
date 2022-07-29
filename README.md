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
> source("~/path_to/configure_wf.R")
```

or using the terminal as

```bash
$ Rscript ~/path_to/execute_wf.R ~/path_to/aConfigFile.R 
```

If you try this just after downloading _RSeqFlow_, it will not work because you have to accommodate it to your computer environment. So, read carefully the next section before launching _RSeqFlow_ for the first time.


## Configuration of RSeqFlow

You’ll need to change a few things to accommodate _RSeqFlow_ to your needs. Make sure that the parameters in the `configure_wf.R` file are properly changed to specify:

* the project name
* the path to the directory of _RSeqFlow_
* if you want to update R packages before running _RSeqFlow_
* if you want a verbose or clean report
* the path to the directory containing your mapped count data
* several variables to read your files correctly
* the experimental factors to analyse
* the correspondence between experimental factors and read data
* the contrast that you will analyse using the experimental factors
* threshold values for several parameters
* a list of gene IDs that you are specially interested in from your data files.

You can have as many copies of `configure_wf.R` file as you want for different data or different parameters. They can be located wherever you want in your computer. But you need to configure some of the values before the first run to avoid error messages.

### Before the first run

#### Define SOURCE_DIR

Locate in your `RSeqFlow` directory the file `configure_wf.R`. You will see a chunk entitled `DON'T TOUCH: CLEAN START` marking the three commands that you must not modify. 

The next chunk corresponds to `PATH TO THE DIRECTORY CONTAINING THE SOURCE FILES` in which you can find the line where the `SOURCE_DIR` variable is defined. This variable must contain the path on your computer to the `RSeqFlow` directory (this allows that the duplication of `configure_wf.R` wherever you want in your computer can launch the right version of _RSeqFlow_). Use, as in the original file, `~/` when your `RSeqFlow` directory is inside your `$HOME` (highly recommended), or ask your computer for this path using the `pwd` bash command after moving to this directory:

```{bash}
$ cd ~/MyFiles/RScripts/RSeqFlow/ 
$ pwd
```

to obtain, for example,

```
/Users/myusername/MyFiles/RScripts/RSeqFlow/
```

or, in another computer,

```
/mnt/home/users/myusername/MyFiles/RScripts/RSeqFlow/
```


that you must incorporate within quotes as any of this three commands:

`SOURCE_DIR = "/Users/myusername/MyFiles/RScripts/RSeqFlow/"`

`SOURCE_DIR = "/mnt/home/users/myusername/MyFiles/RScripts/RSeqFlow/"`

`SOURCE_DIR = "~/MyFiles/RScripts/RSeqFlow/"`

**Do not forget the `/` at the end of the path.**


#### Define DATA_DIR

asassas

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
