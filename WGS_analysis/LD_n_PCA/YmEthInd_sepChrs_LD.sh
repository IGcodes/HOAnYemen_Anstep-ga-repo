#!/usr/bin/bash
#PBS -l nodes=1:ppn=20

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/biallelic_phased_VCFs

for chr in `cat chrIDs.txt`

do 

# registering VCF file name
VCF=YmEthInd_${chr}_BA_Phased.vcf.gz.vcf.gz

plink --vcf $VCF --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--maf 0.01 --geno 0.1 --mind 0.5 --chr ${chr} \
--thin 0.1 -r2 gz --ld-window 100 --ld-window-kb 1000 \
--ld-window-r2 0 \
--make-bed --out YmEthInd_${chr}_LD
done