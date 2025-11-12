import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# Input parameters
K = 3
q_file = f"final_admixture.{K}.Q"
fam_file = "final_admixture.fam"
metadata_file = "WGS_sample_loc_det.csv"
output_plot = f"YmEthSml_admixture_plot_K{K}_with_location_bars.png"

# Step 1: Load .Q file (ancestry proportions)
q_data = np.loadtxt(q_file)

# Step 2: Load .fam file (individual IDs)
fam_data = pd.read_csv(fam_file, delim_whitespace=True, header=None, usecols=[0, 1], names=["FID", "IID"])

# Step 3: Load metadata
metadata = pd.read_csv(metadata_file)

# Step 4: Merge fam data with metadata
fam_data = fam_data.merge(metadata, left_on="IID", right_on="ind", how="left")

# Step 5: Combine ancestry proportions and individual IDs
df = pd.DataFrame(q_data, columns=[f"Cluster_{i+1}" for i in range(K)])
df["IID"] = fam_data["IID"]
df["Site"] = fam_data["Site"]
df["Country"] = fam_data["Country"]

# Step 6: Sort individuals by site and ancestry
# df_sorted = df.sort_values(by=["Country", "Site", f"Cluster_1"], ascending=[True, True, False])
# df_sorted = df.set_index("IID").loc[fam_data["IID"]].reset_index()
# df_sorted = df.copy()  # Keep the original order

# Step 6: Sort individuals by site (or country, if you prefer)
df_sorted = df.sort_values(by=[f"Cluster_{i+1}" for i in range(K)], ascending=False)

# Step 7: Prepare plot
fig, ax = plt.subplots(figsize=(40, 8))

bottom = np.zeros(df_sorted.shape[0])
x = np.arange(len(df_sorted))

# Main admixture plot (cluster colors)
for i in range(K):
    ax.bar(x, df_sorted[f"Cluster_{i+1}"], bottom=bottom, width=0.8, label=f"Cluster {i+1}")
    bottom += df_sorted[f"Cluster_{i+1}"]

# Step 8: Add population and country color bars on top

# Color palettes
# Define color palette for sites with enough unique colors
site_palette = sns.color_palette("husl", n_colors=df_sorted["Site"].nunique())
site_color_map = dict(zip(df_sorted["Site"].unique(), site_palette))

country_palette = sns.color_palette("Set2", n_colors=df_sorted["Country"].nunique())
country_color_map = dict(zip(df_sorted["Country"].unique(), country_palette))

# Define spacing
admixture_top = 1.0
gap_between_admixture_and_site = 0.12
site_bar_height = 0.02
gap_between_site_and_country = 0.58
country_bar_height = 0.05

# Add site color bar (with gap)
site_bar_bottom = admixture_top + gap_between_admixture_and_site
#for xi, site in zip(x, df_sorted["Site"]):
#    ax.bar(xi, site_bar_height, bottom=site_bar_bottom, color=site_color_map[site], width=1.0, edgecolor='none')

# Add site names as text labels above the bars
for xi, site in zip(x, df_sorted["Site"]):
    ax.text(xi, site_bar_bottom + (site_bar_height / 2) + 0.22, site,
            ha='center', va='center', rotation=90, fontsize=23, clip_on=False)

# Add country color bar (with gap)
country_bar_bottom = site_bar_bottom + site_bar_height + gap_between_site_and_country
for xi, country in zip(x, df_sorted["Country"]):
    ax.bar(xi, country_bar_height, bottom=country_bar_bottom, color=country_color_map[country], width=0.8, edgecolor='none')


# Step 9: Beautify plot
ax.set_title(f"Admixture of YmEthSml WGS samples (K={K})", fontsize=35)
ax.set_xlabel("Sample IDs", fontsize=26)
ax.set_ylabel("Ancestry Proportion", fontsize=26)
ax.set_xticks(x)
ax.set_xticklabels(df_sorted["IID"], rotation=90, fontsize=15)
ax.set_yticks(np.linspace(0, 1, 6))
ax.set_yticklabels(np.round(np.linspace(0, 1, 6), 2), fontsize=20)
ax.legend(loc="upper right", fontsize="small", title="Clusters")
ax.set_ylim(0, country_bar_bottom + country_bar_height + 0.05)  # Add some space

# Step 10: Create legends for site and country
from matplotlib.patches import Patch

# site_patches = [Patch(color=color, label=site) for site, color in site_color_map.items()]
country_patches = [Patch(color=color, label=country) for country, color in country_color_map.items()]

#legend1 = ax.legend(handles=site_patches, title="Site", loc='upper center', bbox_to_anchor=(0.5, -0.08), ncol=len(site_color_map), fontsize='small', title_fontsize='small')
#ax.add_artist(legend1)

legend2 = ax.legend(handles=country_patches, title="Country", loc='lower right', bbox_to_anchor=(0.9, -0.55), ncol=len(country_color_map), fontsize=20, title_fontsize=25)
ax.add_artist(legend2)

plt.tight_layout()
plt.savefig(output_plot, dpi=300, bbox_inches='tight')
plt.close()

print(f"Admixture plot saved as {output_plot}")
