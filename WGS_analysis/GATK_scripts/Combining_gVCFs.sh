#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# setting working directory
cd /data/gunarathnai/

# Set paths - Replace with the path to your Apptainer image
CONTAINER_PATH="/data/gunarathnai/Apptainer_containers/gatk4TCLab.sif"

for chr in `cat /data/gunarathnai/Ans_GA/gatk_variants/chrIDs.txt`

do

apptainer exec "$CONTAINER_PATH" gatk --java-options "-Xms8G -Xmx8G" GenomicsDBImport \
  --genomicsdb-workspace-path /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/YmEthInd_gdb_workspace/${chr}_gdb \
  --intervals ${chr} \
  --tmp-dir /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/gdb_tmp \
  -R /data/gunarathnai/Ans_GA/gatk_variants/ref_genome/UCI_ANSTEP_V1.fna \
  --sample-name-map /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/YmEthInd.sample_map \
  --reader-threads 5

done
