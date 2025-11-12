#!/usr/bin/bash
#PBS -l nodes=1:ppn=5

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

# Creating GATK compatible index for the reference genome
#apptainer exec "$CONTAINER_PATH" gatk CreateSequenceDictionary -R /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.fna \
#-O /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.dict


# Iterating over file names
for sbamfile in `ls /data/gunarathnai/Ans_GA/Ethiopia_B2/dedup_bams/*_dedup.bam`
do

apptainer exec "$CONTAINER_PATH" gatk --java-options "-Xms4G -Xmx4G -XX:ParallelGCThreads=2" BaseRecalibrator \
	-I $sbamfile \
	-R /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/ref_genome/UCI_ANSTEP_V1.fna \
	--known-sites /data/gunarathnai/Ans_GA/WG_bam/sorted_bams/MD_bams/known_sites/Astp_IndCh.calls.norm.flt-indels.vcf.gz \
	-O ${sbamfile}_bqsr.report
done

	
