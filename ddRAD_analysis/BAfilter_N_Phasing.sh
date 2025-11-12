#!/usr/bin/bash
#PBS -l nodes=1:ppn=5

# setting working directory
cd /data/gunarathnai/Ans_GA/ddRad_variants


# filtering biallelic variants
bcftools view -Oz -m 2 -M 2 ddRAD_autosomal_ons.vcf.gz -o ddRAD_autosomal_ons_BAFlt.vcf.gz --threads 5

# indexing the input file
bcftools index ddRAD_autosomal_ons_BAFlt.vcf.gz -@ 5

# Pahsing biallelic VCF file using beagle 5.4
java -Xmx200g -jar /home/gunarathnai/bin/beagle/beagle_V5.4.jar \
	nthreads=5 burnin=5 iterations=20 \
	gt=ddRAD_autosomal_ons_BAFlt.vcf.gz \
	out=ddRAD_autosomal_ons_BA_Phased.vcf.gz
   
