#!/usr/bin/bash
#PBS -l nodes=1:ppn=20

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/biallelic_phased_VCFs

# registering VCF file name
VCF=YmEthOnly_allChrs_BA_Phased.vcf.gz

plink --vcf $VCF --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--maf 0.01 --geno 0.1 --mind 0.5 \
--thin 0.1 -r2 gz --ld-window 100 --ld-window-kb 1000 \
--ld-window-r2 0 \
--make-bed --out YmEthOnly_allChrs_LD
