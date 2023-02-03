#!/bin/bash


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
      echo $1 $2 $3 $4 $5 
      ;;
    V) 
      printf "Subset and annotate all samples selected.\n"
      shift $((OPTIND-1)) 
      ;;:w
      
    s) 
      printf "Select single sample subset selected.\n"  
      shift $((OPTIND-1)) 
      echo $1 $2 $3 $4 $5 $6
      ;; 
    S) 
      printf "Select multiple samples subset selected.\n"
      shift $((OPTIND-1)) 
      echo $1 $2 $3 $4 $5
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
