#!/usr/bin/bash
#PBS -l nodes=1:ppn=30

# locating the directory with data
cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/biallelic_phased_VCFs/LD_decay

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'newbio' environment with conda
conda activate newbio

# ADMIXTURE does not accept chromosome names that are not human chromosomes. We will thus just exchange the first column by 0
awk '{$1="0";print $0}' YmEthOnly_allChrs_LD.bim > YmEthOnly_allChrs_LD.bim.tmp
mv YmEthOnly_allChrs_LD.bim.tmp YmEthOnly_allChrs_LD.bim

# Run admixture analysis for each value of K with cross validation
for K in $(seq 2 10)
do
    echo "Running admixture analysis for K=$K..."
    admixture --cv -j30 YmEthOnly_allChrs_LD.bed $K > admixture_K${K}.log

    # Extract cross-validation error
    CV_ERROR=$(grep -o "CV error.*" admixture_K${K}.log | awk '{print $3}')
    echo "K=$K: CV error = $CV_ERROR"
done

# Summarize results
echo "Admixture analysis completed. Cross-validation results:"
grep -h "CV error" admixture_K*.log
