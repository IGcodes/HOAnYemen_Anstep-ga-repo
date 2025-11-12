#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

for chr in `cat /data/gunarathnai/Ans_GA/gatk_variants/chrIDs.txt`

do

apptainer exec "$CONTAINER_PATH" gatk --java-options "-Xmx4g" GenotypeGVCFs \
	-R /data/gunarathnai/Ans_GA/gatk_variants/ref_genome/UCI_ANSTEP_V1.fna \
	-V gendb://Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/YmEthInd_gdb_workspace/${chr}_gdb \
	-O /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/genotyped_VCFs/YmEthInd_${chr}_genotyped.vcf.gz \
	-G StandardAnnotation -G AS_StandardAnnotation \
	--tmp-dir /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/gdb_tmp

done
