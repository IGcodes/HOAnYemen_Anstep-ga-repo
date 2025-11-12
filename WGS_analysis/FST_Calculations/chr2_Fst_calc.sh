#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# locating the directory with data
cd /data/gunarathnai/Ans_GA/all_variants/YmEtInd_all_variants/chr_2

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'newbio' environment with conda
conda activate newbio

vcftools --gzvcf biallelic_phased_YmEtInd_chr2.vcf.gz.vcf.gz --weir-fst-pop Indian_sample_IDs.txt --weir-fst-pop Yemen_sample_IDs.txt --out chr2_YmVsInd_Fst

vcftools --gzvcf biallelic_phased_YmEtInd_chr2.vcf.gz.vcf.gz --weir-fst-pop EthiopianNSomaliLand_sample_IDs.txt --weir-fst-pop Yemen_sample_IDs.txt --out chr2_YmVsEtSml_Fst

vcftools --gzvcf biallelic_phased_YmEtInd_chr2.vcf.gz.vcf.gz --weir-fst-pop EthiopianNSomaliLand_sample_IDs.txt --weir-fst-pop Indian_sample_IDs.txt --out chr2_IndVsEtSml_Fst
