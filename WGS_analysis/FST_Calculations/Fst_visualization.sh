#!/usr/bin/bash
#PBS -l nodes=1:ppn=1

# Loading R module
module load R/4.4.0

# Navigating to the folder with R script and data
cd /data/gunarathnai/Ans_GA/all_variants/YmEtInd_all_variants/Fst_visualization

# Running R script
R --vanilla --file=Ans_GA_Fst_Vis.R