import allel
from Bio import Phylo
from Bio.Phylo.TreeConstruction import DistanceTreeConstructor, DistanceMatrix
import numpy as np
from ete3 import Tree #, TreeStyle

# Step 1: Load the VCF file and extract sample names and genotype data
vcf_file = 'ddRAD_autosomal_WOZabid_BAFlt.vcf'  # Replace with your VCF file path
callset = allel.read_vcf(vcf_file)
sample_names = callset['samples']
genotypes = allel.GenotypeArray(callset['calldata/GT'])

# Step 2: Convert genotypes to haplotypes (0, 1, or 2 to represent allele counts)
haplotypes = genotypes.to_n_alt()  # Convert genotypes to allele counts

# Step 3: Calculate the pairwise distances and store in lower triangular format
def calculate_lower_triangle_distance_matrix(haplotypes):
    n_samples = haplotypes.shape[1]
    dist_matrix = []

    for i in range(n_samples):
        row = []
        for j in range(i):  # Only calculate for lower triangle
            dist = np.sum(haplotypes[:, i] != haplotypes[:, j])  # Count allele differences
            row.append(dist)
        row.append(0)  # Diagonal elements (distance to self)
        dist_matrix.append(row)

    return dist_matrix

dist_matrix = calculate_lower_triangle_distance_matrix(haplotypes)

# Step 4: Convert the distance matrix to a format compatible with Bio.Phylo
labels = list(sample_names)  # Original sample names from VCF
matrix = DistanceMatrix(names=labels, matrix=dist_matrix)

# Step 5: Construct the tree using the distance matrix
constructor = DistanceTreeConstructor()
tree = constructor.nj(matrix)  # Using Neighbor-Joining (NJ) method

# Step 6: Save the tree to a Newick file using Bio.Phylo
newick_file = "temp_tree.nw"
Phylo.write(tree, newick_file, "newick")

# Step 7: Load the Newick file with ete3
ete_tree = Tree(newick_file, format=1)

# Step 8: Rename the leaves in the ete3 tree to match original sample names
# Create a dictionary mapping new leaf names to original sample names
leaf_names = ete_tree.get_leaf_names()
name_mapping = {leaf: sample for leaf, sample in zip(leaf_names, sample_names)}

# Rename leaves in the ete3 tree
for leaf in ete_tree:
    if leaf.name in name_mapping:
        leaf.name = name_mapping[leaf.name]

# Step 9: Save the renamed tree
ete_tree.write(format=1, outfile="phylogenetic_tree_renamed.nw")

# Optional: Save the tree as an image
ete_tree.render("phylogenetic_tree_renamed.png", w=800, units="px")
