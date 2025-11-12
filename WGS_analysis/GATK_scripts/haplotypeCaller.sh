#!/usr/bin/bash
#PBS -l nodes=1:ppn=36

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

# Iterating over file names
for sID in `cat /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/BQSR_bams/sample_names.txt`
do

apptainer exec "$CONTAINER_PATH" gatk --java-options "-Xms120G -Xmx120G -XX:ParallelGCThreads=15" HaplotypeCaller \
   -R /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.fna \
   -I /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/BQSR_bams/${sID}_bqsr.bam \
   -O /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/BQSR_bams/${sID}.g.vcf \
   -ERC GVCF \
   --native-pair-hmm-threads 20

done
