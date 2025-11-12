#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# locating the directory with data
cd /data/gunarathnai/Ans_GA/all_variants/YmEtInd_all_variants/chr_3

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'newbio' environment with conda
conda activate newbio

vcftools --gzvcf biallelic_phased_YmEtInd_chr3.vcf.gz.vcf.gz --weir-fst-pop Indian_sample_IDs.txt --weir-fst-pop Yemen_sample_IDs.txt --out chr3_YmVsInd_Fst

vcftools --gzvcf biallelic_phased_YmEtInd_chr3.vcf.gz.vcf.gz --weir-fst-pop EthiopianNSomaliLand_sample_IDs.txt --weir-fst-pop Yemen_sample_IDs.txt --out chr3_YmVsEtSml_Fst

vcftools --gzvcf biallelic_phased_YmEtInd_chr3.vcf.gz.vcf.gz --weir-fst-pop EthiopianNSomaliLand_sample_IDs.txt --weir-fst-pop Indian_sample_IDs.txt --out chr3_IndVsEtSml_Fst
