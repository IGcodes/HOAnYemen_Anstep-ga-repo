#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

for chr in `cat /data/gunarathnai/Ans_GA/gatk_variants/chrIDs.txt`

do

# Define paths for input VCF and reference genome
INPUT_VCF="/data/gunarathnai/Ans_GA/gatk_variants/genotyped_VCFs/EnI_${chr}_genotyped.vcf.gz"  # Replace with your VCF file
REFERENCE_GENOME="/data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.fna"  # Replace with your reference genome file
OUTPUT_VCF="/data/gunarathnai/Ans_GA/gatk_variants/genotyped_VCFs/EnI_${chr}_flt.vcf.gz"

# Run VariantFiltration with filters optimized for RNA-seq data
apptainer exec "$CONTAINER_PATH" gatk VariantFiltration \
   -R $REFERENCE_GENOME \
   -V $INPUT_VCF \
   -O $OUTPUT_VCF \
   --filter-name "LowQual" --filter-expression "QUAL < 30.0" \
   --filter-name "LowQD" --filter-expression "QD < 2.0" \
   --filter-name "LowDepth" --filter-expression "DP < 10" \
   --filter-name "StrandBias" --filter-expression "FS > 60.0" \
   --filter-name "ReadPosRank" --filter-expression "ReadPosRankSum < -8.0" \
   --filter-name "MappingQuality" --filter-expression "MQ < 40.0" \
   --filter-name "SOR" --filter-expression "SOR > 3.0"

done