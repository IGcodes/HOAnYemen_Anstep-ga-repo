#!/usr/bin/bash
#PBS -l nodes=1:ppn=35

# setting working directory
cd /data/gunarathnai/Ans_GA/Ethiopia_B2/sorted_bams

# Set paths
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif" # Replace with the path to your Apptainer image

# Iterating over file names
for sbamfile in `ls *.sorted.bam`
do

# Extracting sample name from the input file name
sID=$(echo $sbamfile | cut -d "." -f 1)

# Adding read group data since it was not included in the bam files
apptainer exec "$CONTAINER_PATH" gatk AddOrReplaceReadGroups I=${sbamfile} O=${sID}.sorted.rg.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$sbamfile

# Running MarkDuplicate on bam files with read group data
apptainer exec "$CONTAINER_PATH" gatk MarkDuplicatesSpark -I ${sID}.sorted.rg.bam -O ${sID}_dedup.bam -M ${sID}_metrics.txt --spark-master local[35] #--remove-all-duplicates

done