#!/usr/bin/bash
#PBS -l nodes=1:ppn=10
#PBS -k doe

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/biallelic_phased_VCFs/autosomal_fasta_alignments/conactenated_fasta_file

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'newbio' environment with conda
conda activate newbio

# running raxmlHPC to generate the tree files
raxmlHPC-PTHREADS -T 10 -f a -x 95538 -p 95538 -N 1000 -m GTRGAMMA -k -n all_autosomal_BAPhased.tre -s all_autosomal_genomes.fasta