#!/usr/bin/bash
#PBS -l nodes=1:ppn=10
#PBS -k doe

set -e

echo "Job started on $(date)"
conda info
conda list

cd /data/gunarathnai/Ans_GA/gatk_variants/YmEthSmlInd_variants/YmEthInd_Combined/IndYmEthSml_individual_gVCFs/biallelic_phased_VCFs/admixture_analysis/YmEthSml_ddRAD

# Prepare PLINK files
## Exclude SNPs with Minor Allele Frequency  lower than 0.01 and Genotype missingness per SNP greater than 30%, Individual missingness > 10%

plink --vcf autosomal_YmEthSml_ddRAD_intersect.vcf.gz --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--maf 0.01 --geno 0.1 --mind 0.3 \
--make-bed --out autosomal_YmEthSml_ddRAD_intersect_LD

# LD pruning
## Filtering out linkage r sqrd greater than 0.3 for 50 variants window with a step size of 5

plink --bfile autosomal_YmEthSml_ddRAD_intersect_LD --indep-pairwise 50 5 0.3 --out pruned_snps --allow-extra-chr 
plink --bfile autosomal_YmEthSml_ddRAD_intersect_LD --extract pruned_snps.prune.in --make-bed --out final_admixture --allow-extra-chr

# Activate conda environment
eval "$(conda shell.bash hook)"
conda activate newbio

# Rename chromosome names to "0"
awk '{$1="0";print $0}' final_admixture.bim > final_admixture.bim.tmp
mv final_admixture.bim.tmp final_admixture.bim

# Run admixture analysis
for K in $(seq 2 10)
do
    echo "Running admixture analysis for K=$K..."
    admixture --cv -j10 final_admixture.bed $K > admixture_K${K}.log

    CV_ERROR=$(grep -o "CV error.*" admixture_K${K}.log | awk '{print $3}')
    echo "K=$K: CV error = $CV_ERROR"
done

# Summarize CV errors
grep -h "CV error" admixture_K*.log > cross_validation_summary.txt
echo "Admixture analysis completed. Summary written to cross_validation_summary.txt"








