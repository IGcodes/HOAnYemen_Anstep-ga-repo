#!/usr/bin/bash
#PBS -l nodes=1:ppn=30
#PBS -k doe

# setting working directory
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/IndYmEthSml_individual_gVCFs/filtered_YmEthIndSml_VCFs


for VCF in `ls YmEthIndSml_NC_*_fltpass.vcf.gz`

do

# getting sample name
chrID=$(echo "$VCF" | cut -d'_' -f3)

# filtering biallelic variants
#bcftools view -Oz -m 2 -M 2 ${VCF} -o YmEthIndSml_NC_${chrID}_BAFlt.vcf.gz --threads 30

# indexing the input file
bcftools index YmEthIndSml_NC_${chrID}_BAFlt.vcf.gz

# Pahsing biallelic VCF file using beagle 5.4
java -Xmx200g -jar /home/gunarathnai/bin/beagle/beagle_V5.4.jar \
	nthreads=30 burnin=5 iterations=20 \
	gt=YmEthIndSml_NC_${chrID}_BAFlt.vcf.gz \
	out=../biallelic_phased_VCFs/YmEthIndSml_NC_${chrID}_BA_Phased.vcf.gz
   
done