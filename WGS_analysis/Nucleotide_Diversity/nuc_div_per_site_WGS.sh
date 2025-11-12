#!/usr/bin/bash
#PBS -l nodes=1:ppn=5
#PBS -k doe

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/IndYmEthSml_individual_gVCFs/biallelic_phased_VCFs

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'newbio' environment with conda
conda activate newbio

# Define your input and output file names
VCF_FILE="autosomal_YmEthIndSml_BA_Phased.vcf"
OUTPUT_FILE="nuc_div_results/autosomal_YmEthIndSml_BA_Phased.nucleotide_diversity.per_site.pi"

# Run VCFtools to calculate nucleotide diversity per SNP
vcftools \
    --vcf "$VCF_FILE" \
    --site-pi \
    --out nucleotide_diversity_per_site_output

# Rename the output file for convenience
mv nucleotide_diversity_per_site_output.sites.pi "$OUTPUT_FILE"

echo "Nucleotide diversity calculation per site completed. Results saved to $OUTPUT_FILE"
