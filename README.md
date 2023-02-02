# subsetVCF 

SubsetVCF is a script I am writing to ease my workflow in my Master's thesis 
project. Its main functionality is to subset VCF files by gene region, sample
id, or multiple sample id's. Upcoming commits will add table annotation (with 
table_annovar.pl) capabilities through 
[Annovar](https://annovar.openbioinformatics.org/en/latest/), 
and also for the subsetting of BAM files. This readme will be updated when 
those features are implemented. 

### Usage

subsetVCF.sh is the main (and currently only) script. It will work with hg38 
(human) and I am unsure about usage with other reference genomes. The script is 
meant to be used on an HPC, specifically the Compute Canada clusters. As such
it uses calls to the module command which will not work when running locally. 
Lastly, this tool uses other programs which it assumes are preinstalled such
as [bcftools](https://samtools.github.io/bcftools/howtos/index.html), 
[samtools](http://www.htslib.org/), and 
[Annovar](https://annovar.openbioinformatics.org/en/latest/). 

Options passable are (alphabetical order): 

- -a to annotate a single VCF with Annovar 
    - Command: -a \<dir> \<string1> \<string2> \<VCF> 
    - \<dir> is the directory containing the databases Annovar will use for 
    table annotation (with table_annovar.pl). 
    - \<string1> is the list of protocols to use (i.e. "refGene,cytoBand")
    - \<string2> is the list of operations to use (i.e. "g,r") 
    - \<VCF> is the input VCF. 

- -A to annotate many VCFs with Annovar 
    - Command: -A \<dir> \<file> \<string1> \<string2> \<id>
    - \<dir> is the directory containing the databases Annovar will use for 
    table annotation (with table_annovar.pl). 
    - \<file> is the file containing a list of VCFs to be annotated.
    - \<string1> is the list of protocols to use (i.e. "refGene,cytoBand")
    - \<string2> is the list of operations to use (i.e. "g,r") 
    - \<id> is the id that will be used to identify the output directory.

- -v to subset all samples in the input VCF 
    - Command: -v \<chrom> \<start_pos> \<end_pos> \<id> \<VCF> 
    - \<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    - \<id> is the id that will be used to identify the output directory.
    - \<VCF> is the input VCF.

- -V to subset and annotate all samples in the input VCF 
    - Command: -V \<dir> \<string1> \<string2> \<chrom> \<start_pos> \<end_pos> 
    \<id> \<VCF>
    - \<dir> is the directory containing the databases Annovar will use for 
    table annotation (with table_annovar.pl). 
    - \<string1> is the list of protocols to use (i.e. "refGene,cytoBand")
    - \<string2> is the list of operations to use (i.e. "g,r") 
    - \<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    - \<id> is the id that will be used to identify the output directory.
    - \<VCF> is the input VCF.

- -s to select only one sample for subsetting in the input VCF 
    - Command: -s \<sample> \<chrom> \<start_pos> \<end_pos> \<id> \<VCF> 
    - \<sample> is the single sample id as found in the input VCF.
    - \<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    - \<id> is the id that will be used to identify the output directory.
    - \<VCF> is the input VCF. 

- -S to select many samples for subsetting in the input VCF 
    - Command: -S \<file> \<chrom> \<start_pos> \<end_pos> \<id> \<VCF>
    - \<file> is the file containing a list of samples to be annotated.
    - \<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    - \<id> is the id that will be used to identify the output directory.
    - \<VCF> is the input VCF. 

Any list input should be of the form: 

sample1\
sample2\
sample3\
...

## Examples

#### -a 

Command: -a annover_db vcf1 in.vcf 

Output will be a file containing annotated variants from the input VCF. 

#### -A 

Command: -A annovar_db vcf_list exID

Output will be a directory "outdir_exID" with files containing annotated 
variants for all VCFs as indicated in the vcf_list. See above for list format. 

#### -v 

Command: -v 13 32315508 32400268 BRCA2 in.vcf 

Output will be a directory "outdir_BRCA2" with subsetted VCFs for the given 
region, for all samples in the VCF. 

#### -V 

Command: -V annovar_db 13 32315508 32400268 BRCA2 in.vcf 

Output will be a directory "outdir_BRCA2" with subsetted VCF's for each 
sample in the input VCF, and annotation for each aforementioned subsetted VCF.

#### -s 

Command: -s sample1 13 32315508 32400268 BRCA2 in.vcf  

Output will be a directory "outdir_BRCA2" with subsetted VCFs for the given 
region, but only for the sample specified. 

#### -S 

Command: -S sample_list 13 32315508 32400268 BRCA2 in.vcf 

Output will be a directory "outdir_BRCA2" with subsetted VCFs for the given 
region, but only for the samples specified in the sample_list file. See above 
for list format.  


