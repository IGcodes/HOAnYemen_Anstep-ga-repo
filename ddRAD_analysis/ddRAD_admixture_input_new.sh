#!/usr/bin/bash
#PBS -l nodes=1:ppn=2

# locating the directory with data
cd /data/gunarathnai/Ans_GA/ddRad_variants

plink --vcf ddRAD_autosomal_WOZabid_BAFlt.vcf.gz --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--maf 0.01 --geno 0.1 --mind 0.1 \
--make-bed --out ddRAD_autosomal_WOZabid_BAFlt_LD

plink --bfile ddRAD_autosomal_WOZabid_BAFlt_LD --indep-pairwise 50 5 0.2 --out pruned_snps --allow-extra-chr
plink --bfile ddRAD_autosomal_WOZabid_BAFlt_LD --extract pruned_snps.prune.in --make-bed --out final_admixture --allow-extra-chr
