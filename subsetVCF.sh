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
function annoVCF {  
    #load modules
    module load annovar 

    #load databases for annovar to use.
    #this function loads selected databases mentioned
    #by annovar to be of use in WGS analyses.
    #Note that the VCF files from the DNAseq pipeline in GenPipes (C3G) 
    #should already be annotated with dbSNP, SnpEff, and dbNSFP 
    #This script will add additonal clinical information from 
    #ClinVar - clinvar_20221231

    #enter VCF directory and annotate each 
    cd outdir_$1 
    for file in *; do 

    done 
}

#function for the -a option. Mean to annotate a single VCF. 
function annoOneVCF { 
} 

#function for the -A option. Meant to annotate a sequence of VCF files.  
function annoMultiVCF { 
} 

while getopts 'a:A:vVs:S:h' OPTION; do
  case "$OPTION" in 
    a) 
      printf "Annovar annotate one VCF option selected.\n"
      sample=$OPTARG
      shift $((OPTIND-1))
      ;; 
    A)
      printf "Annovar annotate multiple VCF's selected.\n" 
      inputFile=$OPTARG 
      shift $((OPTIND-1)) 
      ;;
    v) 
      printf "Subset all samples selected.\n"  
      shift $((OPTIND-1))
      subVCF $1 $2 $3 $4 $5 
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
      ;; 
    S) 
      printf "Select multiple samples subset selected.\n"
      inputFile=$OPTARG 
      shift $((OPTIND-1)) 
      subMultiVCF $1 $2 $3 $4 $5 $inputFile
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


