# HISEA
Hierarchical SEed Aligner 

## -- OVERVIEW --

HISEA is an efficient all-vs-all long read aligner for SMRT sequencing data. Its algorithm is designed to produce highest alignment sensitivity among others. 

The evaluation of HISEA genome assembly is performed using 30X and 50X sub-sampled data extracted from original datasets downloaded from [Pacific Biosciences DevNet Datasets](https://github.com/PacificBiosciences/DevNet/wiki/Datasets). The 30X and 50X coverage datasets were sampled using the utility fastqSample available from the Canu pipeline.

The HISEA configuration files used for 30X Canu assembly pipeline can be downloaded from the table below. For 50X, same configuration file was used with modification of __corHiseaSensitivity__ parameter set to __normal__.

Genome | Configuration File Links
:--- | :--- 
E.coli | [E.coli configuration](http://www.csd.uwo.ca/faculty/ilie/HISEA/conf_files/ecoli_conf.txt) 
S.cerevisiae | [S.cerevisiae configuration](http://www.csd.uwo.ca/faculty/ilie/HISEA/conf_files/scerevisiae_conf.txt)
C.elegans | [C.elegans configuration](http://www.csd.uwo.ca/faculty/ilie/HISEA/conf_files/celegans_conf.txt)
A.thaliana | [A.thaliana configuration](http://www.csd.uwo.ca/faculty/ilie/HISEA/conf_files/arabidopsis_conf.txt)
D.melanogaster | [D.melanogaster configuration](http://www.csd.uwo.ca/faculty/ilie/HISEA/conf_files/drosophila_conf.txt)

The detailed comparison of HISEA with other leading programs can be found in HISEA paper (Nilesh Khiste and Lucian Ilie). Below are some plots showing different comparisons.


## -- Sensitivity Comparisons --


<img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/Sensitivity_ecoli.jpg" width="480" height="288" alt="E.coli"> | <img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/Sensitivity_scerevisiae.jpg" width="480" height="288" alt="S.cerevisiae"> 
--- | --- 
<img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/Sensitivity_celegans.jpg" width="480" height="288" alt="C.elegans"> | <img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/Sensitivity_Arabidopsis.jpg" width="480" height="288" alt="A.thaliana">
<img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/Sensitivity_droso.jpg" width="480" height="288" alt="D.melanogaster"> |

## -- NGA50 Comparisons --

<img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/nga50_ecoli.jpg" width="480" height="288" alt="E.coli"> | <img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/nga50_scerevisiae.jpg" width="480" height="288" alt="S.cerevisiae"> 
--- | --- 
<img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/nga50_celegans.jpg" width="480" height="288" alt="C.elegans"> | <img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/nga50_Arabidopsis.jpg" width="480" height="288" alt="A.thaliana">
<img src="http://www.csd.uwo.ca/faculty/ilie/HISEA/images/nga50_droso.jpg" width="480" height="288" alt="D.melanogaster"> |


## -- INSTALLATION --

Once the zip file has been downloaded, please use following commands to unzip and compile the HISEA program:

```javascript 
1. unzip HISEA.zip   -- This will create a directory HISEA and all required files in this folder

2. cd HISEA          -- Change directory to HISEA

3. make              -- This will compile the HISEA code and create hisea file for use
```

This command will build the hisea binary. If you see any error messages, please contact authors.

##-- RUNNING HISEA --

The HISEA program can be used with fastA/fastQ files with one or more sequences. The program can be run in both serial and parallel mode. The parallel mode has an advantage in terms of time with respect to serial mode. HISEA can be run with minimal set of mandatory parameters, --ref and --query. For self alignment, HISEA only needs two options --self and --ref. All other parameter will assume their default values.

```javascript 
USAGE:
  hisea [--self] [--kmerLen  <int>] [--minStoreLen <int>] [--minOlapLen <int>] --ref <file/directory> --query <file/directory>

  For full list of options type "hisea --help"

OUTPUT:
     stdout  List of alignments
```

The complete set of options for hisea program are:

```javascript 
Options:
--help         no_arg     Print this help message
--self         no_arg     Align set of reads with itself. Use only --ref option
--ref          <file/dir> The name of the reference fasta/fastq file or directory
                          containing these files
--query        <file/dir> The name of the query fasta/fastq file or directory
                          containing these files
--ignore       <file>     The file containing kmers to be ignored
--index_write  <dir>      The directory where index is stored
--index_read   <dir>      The directory from whcih index is read
--kmerLen      <int>      This is the kmer length used for initial hashing.
                          The possible values are 10-20, both inclusive
                          default=16
--smallkmerLen <int>      This is the kmer length used during alignment extension.
                          The possible values are 10-20, both inclusive
                          default=12
--filterCount  <int>      This is used for initial filtering. This must be set to 1,
                          if index is created with split set of reads.
                          default=2
--threads      <int>      Number of threads for parallel run
                          default=1
--minOlapLen   <int>      Minimum Overlap length
                          default=100
--minStoreLen  <int>      Minimum read length. Overlap of two smaller reads is ignored
                          default=100
--minMatches   <int>      Minimum number of matches to be considered for alignment
                          default=3
--maxKmerHits  <int>      The maximum number of repeat kmers
                          default=10000
--errorRate    <float>    Error rate. Valid values are 0-1 percent
                          default=0.15
--maxShift     <float>    The value of shift to accomodate indels. Valid values
                          are 0-1 percent
                          default=0.20
```

The [Canu+HISEA](http://canu.readthedocs.io/en/latest/) pipeline uses exactly same command line options as [Canu+MHAP](http://canu.readthedocs.io/en/latest/) pipeline. We have defined new configuration file parameters for running HISEA in this pipeline.

```javascript 
Below are HISEA the parameters for configuration file:

<tag>HiseaBlockSize
Chunk of reads that can fit into 1GB of memory. Combined with memory to compute the size
of chunk the reads are split into.

<tag>HiseaMerSize
Use k-mers of this size for detecting overlaps.

<tag>HiseaMemory
Memory size per block.

<tag>HiseaSensitivity
Either normal, high, or low

Here is an example of a dummy configuration file, config.txt:

corOverlapper=hisea
corHiseaMerSize=16
corHiseaSensitivity=high
corHiseaMemory=200
corHiseaBlockSize=20000
corOvlRefBlockSize=20000
useGrid=0
```        

## CITE
