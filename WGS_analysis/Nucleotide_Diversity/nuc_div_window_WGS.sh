#!/usr/bin/bash
#PBS -l nodes=1:ppn=5
#Pbs -k doe

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/IndYmEthSml_individual_gVCFs/biallelic_phased_VCFs

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'newbio' environment with conda
conda activate newbio

# Define your input and output file names
VCF_FILE="autosomal_YmEthSml_BA_Phased.vcf"
OUTPUT_FILE="nuc_div_results/autosomal_YmEthSml_BA_Phased.nucleotide_diversity.windowed.pi"

# Run VCFtools to calculate nucleotide diversity
vcftools \
    --vcf "$VCF_FILE" \
    --window-pi 100000 \
    --window-pi-step 50000 \
    --out nucleotide_diversity_output

# Rename the output file for convenience
mv nucleotide_diversity_output.windowed.pi "$OUTPUT_FILE"

echo "Nucleotide diversity calculation completed. Results saved to $OUTPUT_FILE"
