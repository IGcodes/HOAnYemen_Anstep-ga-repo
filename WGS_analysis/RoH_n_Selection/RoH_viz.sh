#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/filtered_VCFs/RoH_results

module load python

for pop in `ls *_roh.txt`

do

POPCHR=$(echo $pop | cut -d'.' -f1)

grep '^RG' "$pop" > "${POPCHR}_RG.txt"

python roh_viz2.py ${POPCHR}_RG.txt

done