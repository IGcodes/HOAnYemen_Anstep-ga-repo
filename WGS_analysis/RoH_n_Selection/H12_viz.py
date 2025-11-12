import pandas as pd
import matplotlib.pyplot as plt
import sys
import os

# Check if the input file is provided
if len(sys.argv) != 2:
    print("Usage: python script.py <input_csv_file>")
    sys.exit(1)

# Input file from command-line argument
input_file = sys.argv[1]

# Extract the prefix from the file name
file_name = os.path.basename(input_file)
prefix = file_name.split("_")[3] + "_" + file_name.split("_")[4] # Use the first part of the file name as prefix

try:
    # Read the input CSV file
    data = pd.read_csv(input_file)

    # Check if the required H12 column exists
    if 'H12' not in data.columns:
        raise ValueError("The input file must contain an 'H12' column.")

    # Define the window size and step size
    window_size = 1000  # Window size in base pairs (bp)
    step_size = 500     # Step size in base pairs (bp)

    # Calculate genomic positions
    data['Position'] = data.index * step_size + window_size // 2

    # Plot the scatter plot for H12 values
    plt.figure(figsize=(30, 3))
    plt.plot(data['Position'], data['H12'], color='blue', linewidth=0.5, label='H12')
    plt.title('Genome-wide Distribution of H12 Values', fontsize=16)
    plt.xlabel('Genomic Position (bp)', fontsize=14)
    plt.ylabel('H12', fontsize=14)
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()

    # Save the plot as a PNG file
    output_file = prefix + "_H12_distribution.png"
    plt.savefig(output_file, format='png', dpi=300)
    #plt.show()

    print(f"The scatter plot has been saved as {output_file}.")

except Exception as e:
    print(f"Error: {e}")
