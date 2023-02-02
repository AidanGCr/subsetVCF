# subsetVCF 

SubsetVCF is a script I am writing to ease my workflow in my Master's thesis 
project. Its main functionality is to subset VCF files by gene region, sample
ID, or multiple sample ID's. Upcoming commits will add annotation capabilities 
through [Annovar](https://annovar.openbioinformatics.org/en/latest/), and also
for the subsetting of BAM files. This readme will be updated when those 
features are implemented. 

### Usage

subsetVCF.sh is the main (and currently only) script. It will work with hg38 
(human) and I am unsure about usage with other reference genomes. 

Options passable are (alphabetical order): 

-a to annotate a single sample with Annovar 
    Command: -a <dir> <sample> <chrom> <start_pos> <end_pos> <id> <VCF> 
    - <dir> is the directory containing the databases Annovar will use for 
    region annotation. 
    - <sample> is the single sample ID as found in the VCF that will be analyzed.
    - <chrom>, <start_pos>, <end_pos> all define the region of interest. 
    - <VCF> is the input VCF 

-A to annotate many samples with Annovar 
    Command: -A <dir> <file> <chrom> <start_pos> <end_pos> <id> <VCF>

-v to subset all samples in the input VCF 
    Command: -v <chrom> <start_pos> <end_pos> <id> <VCF> 

-V to subset and annotate all samples in the input VCF 
    Command: -V <dir> <chrom> <start_pos> <end_pos> <id> <VCF>

-s to select only one sample for subsetting in the input VCF 
    Command: -s <sample> <chrom> <start_pos> <end_pos> <id> <VCF> 

-S to select many samples for subsetting in the input VCF 
    Command: -S <file> <chrom> <start_pos> <end_pos> <id> <VCF>

