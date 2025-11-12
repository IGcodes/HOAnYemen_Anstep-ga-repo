#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

for chr in `cat /data/gunarathnai/Ans_GA/gatk_variants/chrIDs.txt`

do

# Define paths for input VCF and reference genome
INPUT_VCF="/data/gunarathnai/Ans_GA/gatk_variants/genotyped_VCFs/EnI_${chr}_flt.vcf.gz"  # Replace with your VCF file
REFERENCE_GENOME="/data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.fna"  # Replace with your reference genome file
OUTPUT_VCF="/data/gunarathnai/Ans_GA/gatk_variants/genotyped_VCFs/EnI_${chr}_fltpass.vcf.gz"

# Run VariantFiltration with filters optimized for RNA-seq data
apptainer exec "$CONTAINER_PATH" gatk SelectVariants \
   -R $REFERENCE_GENOME \
   -V $INPUT_VCF \
   --exclude-filtered \
   -O $OUTPUT_VCF \
   
done