#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# locating the directory with data
cd /data/gunarathnai/Ans_GA/ddRad_variants/Jeannes_samples_WOZabid/Fst_calculations

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'bio2' environment with conda
conda activate newbio

# Iterating over VCF files to generate Fst
for VCF in `cat VCFs4Fst.txt`
do

for pp in `cat pop_pairs.txt`
do

POP1=$(echo ${pp} | cut -d',' -f1)
POP2=$(echo ${pp} | cut -d',' -f2)

OUT="$POP1"
OUT+="$POP2"
OUT+="$VCF"

vcftools --gzvcf ${VCF} \
	--weir-fst-pop ${POP1} --weir-fst-pop ${POP2} \
	--fst-window-size 100000 \
	--fst-window-step 50000 \
	--out ${OUT}_Fst

done
done
