# Population Genomics Analysis Code Repository
This repository contains the collection of scripts used for the population genomics analysis of Anopheles stephensi.
The code is organized into three primary analysis pipelines:
1. GATK_scripts: Variant calling and processing (WGS).
2. WGS_analysis: Downstream analysis of WGS data.
3. ddRAD_analysis: Downstream analysis of ddRAD-seq data.
## Project Structure
### ```/WGS_analysis/GATK_scripts/```
This directory holds the shell scripts for the GATK (Genome Analysis Toolkit) pipeline, used for variant calling from raw sequencing data (BAMs) to filtered VCFs.
  * Run_MD.sh: Pre-processes BAM files. It first adds read groups (gatk AddOrReplaceReadGroups) and then removes duplicates (gatk MarkDuplicatesSpark).
  * base_recalibrator.sh: Runs gatk BaseRecalibrator to create a Base Quality Score Recalibration (BQSR) report.
  * bqsr_apply.sh: Applies the BQSR report to the BAM files to create new, recalibrated BAMs.
  * haplotypeCaller.sh: Runs gatk HaplotypeCaller on each recalibrated BAM to create an individual genomic VCF (gVCF).
  * Combining_gVCFs.sh: Merges all individual gVCFs into a single genomic database using gatk GenomicsDBImport.
  * Joint_genotyping.sh: Performs joint variant calling on the combined database using gatk GenotypeGVCFs to create a raw, multi-sample VCF.
  * variant_filtering.sh: Applies hard filters (gatk VariantFiltration) to the raw VCF for quality control (e.g., filtering by QD, FS, MQ, DP).
  * filtering_out.sh: Uses gatk SelectVariants to create a new VCF containing only the variants that passed the filters.
  * BiAllelic_filtering_n_Phasing.sh: Filters the VCF for biallelic SNPs only (bcftools view) and then phases the variants using beagle.
### ```/WGS_analysis/```
This directory holds all scripts for the downstream population genetic analysis of the WGS data.
```/Admixture/```
  * YmEthInd_allChrs_admixture.sh: HPC shell script (PBS) that prepares VCF data and runs admixture with cross-validation for K values 2 through 10.
  * YmEthIndSml_WGS_admixture_plot_Wlocdet.py: Python script using matplotlib to plot admixture proportions (Q-values) for a specific K, organizing samples by country and site metadata.
```/FST_Calculations/```
  * chr2_Fst_calc.sh: HPC shell script using vcftools to calculate Weir & Cockerham's Fst between population pairs on chromosome 2.
  * chr3_Fst_calc.sh: HPC shell script using vcftools to calculate Weir & Cockerham's Fst between population pairs on chromosome 3.
  * Fst_analysis_1.14.2025.ipynb: Jupyter Notebook to read Fst output files, map high-Fst windows to gene annotations, categorize windows by Fst percentile, and export unique gene lists.
  * Plot_Fst.py: Python script using matplotlib to generate a multi-panel scatter plot of windowed Fst values across all chromosomes.
  * Fst_visualization.sh: A simple shell script to launch a custom R script for Fst visualization.
```/LD_n_PCA/```
  * autosomal_YmEthSml_plink_PCA.sh: HPC shell script that uses plink to perform LD pruning (--indep-pairwise) and then run a Principal Component Analysis (PCA) with variable weights.
  * LD_decay_calc.py: Python script that parses the output of plink --r2 to calculate and bin average R^2 values by distance, for plotting LD decay.
  * YmEthInd_allChrs_LD.sh: HPC shell script using plink to filter a VCF and prepare it for LD analysis.
  * YmEthInd_sepChrs_LD.sh: HPC shell script that loops through a list of chromosomes and runs plink to calculate LD for each one separately.
```/Nucleotide_Diversity/```
  * nuc_div_per_site_WGS.sh: HPC shell script using vcftools --site-pi to calculate nucleotide diversity (Pi) for every SNP.
  * nuc_div_window_WGS.sh: HPC shell script using vcftools --window-pi to calculate nucleotide diversity (Pi) in 100kb sliding windows.
  /Phylogenetic_tree/
  * generateNJTree.py: Python script using scikit-allel to read a VCF, calculate a pairwise distance matrix, and then use Bio.Phylo to build and save a Neighbor-Joining (NJ) tree.
  * raxMLHPC_tree.sh: HPC shell script to run raxmlHPC-PTHREADS, a tool for building large-scale maximum-likelihood phylogenetic trees from a concatenated FASTA alignment.
```/RoH_n_Selection/```
  * vcf2zarr_conversion.ipynb: Jupyter Notebook utility to convert VCF files into zarr format, the required array format for scikit-allel.
  * selection_stats.ipynb: Jupyter Notebook using scikit-allel (allel.moving_garud_h) to calculate Garud's H statistics (H1, H12, etc.) in sliding windows across the genome.
  * Garuds_HStat_analysis.ipynb: Jupyter Notebook to read Garud's H-statistic data, align it with variant positions, and map genes to windows with high H-values.
  * fixedNselected_gene_stats.ipynb: Jupyter Notebook to calculate Fst and H12 values specifically for a pre-defined list of gene regions.
  * RoH.sh: HPC shell script that loops through population lists and chromosomes to calculate Runs of Homozygosity using bcftools roh.
  * RoH_Calculation.ipynb: Jupyter Notebook using scikit-allel's Hidden Markov Model (allel.roh_mhmm) to identify and plot ROH and calculate the fraction of the genome in ROH (fROH).
  * H12_viz.py: Python script using matplotlib to plot the genome-wide distribution of H12 values.
  * RoH_viz.sh: HPC shell script to process bcftools roh output files and prepare them for visualization.
```/ddRAD_analysis/```
This directory mirrors many of the analyses from the WGS folder but is applied to the ddRAD-seq dataset.
  * BAfilter_N_Phasing.sh: HPC shell script to filter the ddRAD VCF for bialleleic SNPs (bcftools view) and phase it using beagle.
  * Fst_Calc.sh: HPC shell script to loop through population pairs and calculate windowed Fst using vcftools.
  * admixture_ddRAD.sh: HPC shell script to run admixture (K=2-10) with cross-validation on the ddRAD .bed file.
  * admixture_YmEthSml_ddRAD_4.9.25.sh: A more detailed admixture script that also includes the plink filtering and LD pruning steps.
  * autosomal_LD_PCA_ddRAD_4.9.25.sh: HPC shell script using plink to perform LD pruning and PCA on the ddRAD dataset.
  * ddRAD_admixture_input_new.sh: HPC shell script using plink to filter and LD-prune the ddRAD VCF to create the final .bed file for admixture.
  * generateNJTree.py: Python script (same as in WGS) using scikit-allel and Bio.Phylo to build a Neighbor-Joining tree.
  * selection_stats.ipynb: Jupyter notebook (same as in WGS) using scikit-allel to calculate Garud's H statistics.
  * vcf2zarr_conversion.ipynb: Jupyter notebook utility (same as in WGS) to convert VCFs to zarr format.

