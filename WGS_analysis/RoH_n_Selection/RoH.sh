#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/filtered_VCFs

for pop in `ls *SampleNames.txt`

do

POPNAME=$(echo ${pop} | cut -d'S' -f1)

for CHR in `cat chrIDs.txt`

do

# Input arguments
VCF="YmEthInd_${CHR}_fltpass.vcf.gz"            # Input VCF file
OUTPUT_PREFIX="${POPNAME}_${CHR}"  # Output prefix for results

# Run bcftools roh
echo "Calculating RoH using bcftools roh..."
bcftools roh -S ${pop} --AF-dflt 0.224768 -o ${OUTPUT_PREFIX}_roh.txt $VCF

done

done