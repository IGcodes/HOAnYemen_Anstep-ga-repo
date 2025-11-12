#!/usr/bin/bash
#PBS -l nodes=1:ppn=8

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

# Iterating over file names
for sID in `cat /data/gunarathnai/Ans_GA/Ethiopia_B2/dedup_bams/samplenames.txt`
do

apptainer exec "$CONTAINER_PATH" gatk --java-options "-Xms2G -Xmx2G -XX:ParallelGCThreads=2" ApplyBQSR \
	-I /data/gunarathnai/Ans_GA/Ethiopia_B2/dedup_bams/${sID}_dedup.bam \
	-R /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.fna \
	--bqsr-recal-file /data/gunarathnai/Ans_GA/Ethiopia_B2/dedup_bams/${sID}_dedup.bam_bqsr.report \
	-O /data/gunarathnai/Ans_GA/Ethiopia_B2/dedup_bams/${sID}_bqsr.bam

done
