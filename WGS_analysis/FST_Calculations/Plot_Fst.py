import pandas as pd
import matplotlib.pyplot as plt

# Define the input file path directly in the script
file_path = 'YmEthSampleNames.txtIndianSampleNames.txtYmEthInd_allChrs_BA_Phased.vcf.gz.vcf.gz_Fst.windowed.weir.fst'  # Replace with the path to your Fst file

# Load the Fst data file
try:
    fst_data = pd.read_csv(file_path, sep='\t')
except Exception as e:
    print(f"Error loading file: {e}")
    exit(1)

# Ensure the column names match the data format
chromosome_col = 'CHROM'
fst_col = 'WEIGHTED_FST'
start_col = 'BIN_START'

# Filter out rows with missing Fst values
fst_data = fst_data.dropna(subset=[fst_col])

# Get unique chromosomes
chromosomes = fst_data[chromosome_col].unique()

# Determine the chromosome lengths
chromosome_lengths = {
    chrom: fst_data[fst_data[chromosome_col] == chrom][start_col].max() for chrom in chromosomes
}

# Scale chromosome lengths to avoid oversized figures
max_scaled_length = 50  # Set the maximum scaled width for the largest chromosome
scaling_factor = max_scaled_length / max(chromosome_lengths.values())
scaled_lengths = {chrom: length * scaling_factor for chrom, length in chromosome_lengths.items()}

# Create a multi-panel plot with scaled panel widths
fig, axes = plt.subplots(1, len(chromosomes), 
                         figsize=(max_scaled_length + 4, 6),  # Limit total figure size
                         gridspec_kw={'width_ratios': [scaled_lengths[chrom] for chrom in chromosomes]})

# If there's only one chromosome, wrap the single axis into a list for consistency
if len(chromosomes) == 1:
    axes = [axes]

# Plot each chromosome in its own panel
for ax, chrom in zip(axes, chromosomes):
    chrom_data = fst_data[fst_data[chromosome_col] == chrom]
    ax.scatter(chrom_data[start_col], chrom_data[fst_col], alpha=0.7, s=10)
    ax.set_title(f"Chromosome: {chrom}", fontsize=12)
    ax.set_xlim(0, chromosome_lengths[chrom])
    ax.set_xlabel("Genomic Position (bp)", fontsize=10)
    ax.set_ylabel("Weighted Fst", fontsize=10)
    ax.grid(axis='y', linestyle='--', alpha=0.7)

# Adjust layout
plt.tight_layout()

# Save the plot as a PNG file
output_file = "YemenNEthiopiaVsIndia_fst_scatter_plot_single_row.png"
plt.savefig(output_file, dpi=300)
plt.show()

print(f"Scatter plot saved to {output_file}.")
