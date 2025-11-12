#!/usr/bin/bash
#PBS -l nodes=1:ppn=20
#PBS -k doe

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/IndYmEthSml_individual_gVCFs/biallelic_phased_VCFs

# printing hostname on Kodiak
hostname

# linkage pruning
plink --vcf autosomal_YmEthSml_BA_Phased.vcf \
--double-id \
--allow-extra-chr \
--list-duplicate-vars \
--threads 20 \
--set-missing-var-ids @:#_\$1_\$2 \
--indep-pairwise 50 10 0.1 \
--out autosomal_YmEthSml_BAP_LD

# Performing PCA
# The "var-wts" flag will produce the loadings of the genes for each PC
plink --vcf autosomal_YmEthSml_BA_Phased.vcf \
--double-id \
--allow-extra-chr \
--set-missing-var-ids @:#_\$1_\$2 \
--extract autosomal_YmEthSml_BAP_LD.prune.in \
--list-duplicate-vars --threads 20 \
--make-bed \
--pca var-wts \
--out autosomal_YmEthSml_BAP_PCA
