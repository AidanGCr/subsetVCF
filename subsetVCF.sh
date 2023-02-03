#A script for subsetting VCF files by region, subsetting BAMs, and annotating
#by region with Annovar.
#See the githib for help: https://github.com/AidanGCr/subsetVCF
#Use -a to annotate a single sample with Annovar 
#Use -A to annotate many samples with Annovar 
#Use -v to subset all samples in the input VCF 
#Use -V to subset and annotate all samples in the input VCF
#Use -s to select only one sample for subsetting in the input VCF
#Use -S to select many samples for subsetting in the input VCF 
#Example usage: 
#./subsetVCF.sh -v 17 43044295 43125364 BRCA1 in.vcf

#function for the -v option. Meant to review/subset all samples in a file.
    #Command: -v <chrom> <start_pos> <end_pos> <id> VCF> 
    #<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    #<id> is the id that will be used to identify the output directory.
    #<VCF> is the input VCF.
function subVCF { 
    #load modules 
    module load bcftools

    #printf input VCF, make output directory, establish the output file names
    printf "subsetting VCF with inputs: $1 $2 $3 $4 $5\n" 
    mkdir "outdir_$4"
    fileName="$(basename $5)"
    outFile="outdir_$4/$fileName.subset.vcf.gz"

    #subet the VCF by region
    bcftools view -i '((POS>='$2' & POS<='$3') | (INFO/END>='$2' & INFO/END<='$3')) & CHROM="chr'$1'"' -Oz $5 > $outFile

    #create VCF files by sample using the subsetted VCF 
    for sample in `bcftools view -h $5 | grep "^#CHROM" | cut -f10-`; do
        sampleFileName="outdir_$4/$fileName.$sample.subset.vcf.gz"
        bcftools view -s $sample -Oz $outFile > $sampleFileName
    done
} 

#function for the -s option. Meant to subset for only one sample. 
    #Command: -s <sample> <chrom> <start_pos> <end_pos> <id> <VCF> 
    #<sample> is the single sample id as found in the input VCF.
    #<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    #<id> is the id that will be used to identify the output directory.
    #<VCF> is the input VCF.
function subOneVCF {  
    #load modules 
    module load bcftools

    #printf input VCF, make output directory, establish the output file names
    printf "subsetting VCF with inputs: $1 $2 $3 $4 $5 $6\n" 
    mkdir "outdir_$4"
    fileName="$(basename $5)"
    outFile="outdir_$4/$fileName.subset.vcf.gz"

    #subet the VCF by region
    bcftools view -i '((POS>='$2' & POS<='$3') | (INFO/END>='$2' & INFO/END<='$3')) & CHROM="chr'$1'"' -Oz $5 > $outFile

    #create VCF file for the given single sample using the subsetted VCF 
    sampleFileName="outdir_$4/$fileName.$sample.subset.vcf.gz"
    bcftools view -s $6 -Oz $outFile > $sampleFileName
} 

#function for the -S option. Meant to subset samples from an input file.
    #Command: -S <file> <chrom> <start_pos> <end_pos> <id> <VCF>
    #<file> is the file containing a list of samples to be annotated.
    #<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    #<id> is the id that will be used to identify the output directory.
    #<VCF> is the input VCF. 
function subMultiVCF {  
    #load modules 
    module load bcftools

    #printf input VCF, make output directory, establish the output file names
    printf "subsetting VCF with inputs: $1 $2 $3 $4 $5 $6\n" 
    mkdir "outdir_$4"
    fileName="$(basename $5)"
    outFile="outdir_$4/$fileName.subset.vcf.gz"

    #subet the VCF by region
    bcftools view -i '((POS>='$2' & POS<='$3') | (INFO/END>='$2' & INFO/END<='$3')) & CHROM="chr'$1'"' -Oz $5 > $outFile

    #loop through the input file and produce a subset VCF for each 
    for sample in `grep ".*" $6`; do
        sampleFileName="outdir_$4/$fileName.$sample.subset.vcf.gz"
        bcftools view -s $sample -Oz $outFile > $sampleFileName
    done
}

#function for the -V option. Meant to annotate all subsetted VCFs.
    #Command: -V <dir> <string1> <string2> <chrom> <start_pos> <end_pos> 
    #<id> <VCF>
    #<dir> is the directory containing the databases Annovar will use for 
    #table annotation (with table_annovar.pl). 
    #<string1> is the list of protocols to use (i.e. "refGene,cytoBand")
    #<string2> is the list of operations to use (i.e. "g,r") 
    #<chrom>, <start_pos>, <end_pos> all define the region of interest. 
    #<id> is the id that will be used to identify the output directory.
    #<VCF> is the input VCF.
function annoVCF { 
    #this function uses the -v function subVCF to do the subsetting
    subVCF $4 $5 $6 $7 $8 
 
    #load modules
    module load annovar 

    #enter VCF directory and annotate each output VCF 
    cd outdir_$7
    for file in *.vcf.gz; do 
        gunzip $file 
    done
    for file in *.vcf; do 
        table_annovar.pl $file $1 -buildver hg38 -out $file -remove -protocol $2 -operation $3 -nastring . -vcfinput -polish
    done 
}

#function for the -a option. Mean to annotate a single VCF.
    #Command: -a <dir> <string1> <string2> <VCF> 
    #<dir> is the directory containing the databases Annovar will use for 
    #table annotation (with table_annovar.pl). 
    #<string1> is the list of protocols to use (i.e. "refGene,cytoBand")
    #<string2> is the list of operations to use (i.e. "g,r") 
    #<VCF> is the input VCF.
function annoOneVCF { 
    #load modules
    module load annovar 

    #annotate VCF
    table_annovar.pl $4 $1 -buildver hg38 -out $4 -remove -protocol $3 -operation $4 -nastring . -vcfinput -polish
} 

#function for the -A option. Meant to annotate a sequence of VCF files. 
    #Command: -A <dir> <file> <string1> <string2> <id>
    #<dir> is the directory containing the databases Annovar will use for 
    #table annotation (with table_annovar.pl). 
    #<file> is the file containing a list of VCFs to be annotated.
    #<string1> is the list of protocols to use (i.e. "refGene,cytoBand")
    #<string2> is the list of operations to use (i.e. "g,r") 
    #<id> is the id that will be used to identify the output directory.
function annoMultiVCF {
    #load modules
    module load annovar 

    #make output directory
    dir_name="annovar_out_$5" 
    mkdir $dir_name
    cd $dir_name

    #loop through the input file and annotate each VCF
    for vcf in `grep ".*" $2`; do
        table_annovar.pl $vcf $1 -buildver hg38 -out $4 -remove -protocol $2 -operation $3 -nastring . -vcfinput -polish
    done
} 

while getopts 'a:A:vVs:S:h' OPTION; do
  case "$OPTION" in 
    a) 
      printf "Annovar annotate one VCF option selected.\n"
      db_dir=$OPTARG
      shift $((OPTIND-1))
      annoOneVCF $db_dir $1 $2 $3  
      shift 3 
      ;; 
    A)
      printf "Annovar annotate multiple VCF's selected.\n" 
      db_dir=$OPTARG 
      shift $((OPTIND-1)) 
      annoMultiVCF $db_dir $1 $2 $3 $4
      shift 4 
      ;;
    v) 
      printf "Subset all samples selected.\n"  
      shift $((OPTIND-1))
      subVCF $1 $2 $3 $4 $5
      shift 5 
      ;;
    V) 
      printf "Subset and annotate all samples selected.\n"
      shift $((OPTIND-1)) 
      ;;
    s) 
      printf "Select single sample subset selected.\n" 
      sample=$OPTARG 
      shift $((OPTIND-1)) 
      subOneVCF $1 $2 $3 $4 $5 $sample 
      shift 5
      ;; 
    S) 
      printf "Select multiple samples subset selected.\n"
      inputFile=$OPTARG 
      shift $((OPTIND-1)) 
      subMultiVCF $1 $2 $3 $4 $5 $inputFile
      shift 5
      ;;
    h) 
      printf "Invalid Command\n"
      printf "Visit for help: https://github.com/AidanGCr/subsetVCF\n" 
      ;;
    ?) 
      printf "Invalid Command\n"
      printf "Visit for help: https://github.com/AidanGCr/subsetVCF\n" 
      ;;
  esac
done

exit 1 


