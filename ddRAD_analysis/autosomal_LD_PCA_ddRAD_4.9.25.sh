#!/usr/bin/bash
#PBS -l nodes=1:ppn=5
#PBS -k doe

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/IndYmEthSml_individual_gVCFs/biallelic_phased_VCFs/ddRAD_intersections

# printing hostname on Kodiak
hostname

# linkage pruning
plink --vcf autosomal_YmEthSml_ddRAD_intersect.vcf.gz --double-id --allow-extra-chr --list-duplicate-vars \
--set-missing-var-ids @:#_\$1_\$2 \
--indep-pairwise 50 10 0.1 --out autosomal_YmEthSml_ddRAD_intersect

# Performing PCA
# The "var-wts" flag will produce the loadings of the genes for each PC
plink --vcf autosomal_YmEthSml_ddRAD_intersect.vcf.gz --double-id --allow-extra-chr --set-missing-var-ids @:#_\$1_\$2 \
--extract autosomal_YmEthSml_ddRAD_intersect.prune.in --list-duplicate-vars \
--make-bed --pca var-wts --out autosomal_YmEthSml_ddRAD_intersect_pca


