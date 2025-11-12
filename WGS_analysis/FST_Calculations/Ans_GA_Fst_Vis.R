# Setting working directory
setwd("/data/gunarathnai/Ans_GA/all_variants/YmEtInd_all_variants/Fst_visualization")

# Importing libraries
if (!require(tidyverse, character.only = TRUE)) {
    install.packages("tidyverse")
    library(tidyverse)
}

if (!require(gridExtra, character.only = TRUE)) {
    install.packages("gridExtra")
    library(gridExtra)
}

# Importing data
chr2_IndVsEtSml <- read.table("chr2_IndVsEtSml_Fst.weir.FST", header = TRUE, sep = "\t")
chr2_IndVsEtSml <- chr2_IndVsEtSml %>% filter(! WEIR_AND_COCKERHAM_FST == "NaN")

chr2_YmVsEtSml <- read.table("chr2_YmVsEtSml_Fst.weir.FST", header = TRUE, sep = "\t")
chr2_YmVsEtSml <- chr2_YmVsEtSml %>% filter(! WEIR_AND_COCKERHAM_FST == "NaN")

chr2_YmVsInd <- read.table("chr2_YmVsInd_Fst.weir.FST", header = TRUE, sep = "\t")
chr2_YmVsInd <- chr2_YmVsInd %>% filter(! WEIR_AND_COCKERHAM_FST == "NaN")

chr3_IndVsEtSml <- read.table("chr3_IndVsEtSml_Fst.weir.FST", header = TRUE, sep = "\t")
chr3_IndVsEtSml <- chr3_IndVsEtSml %>% filter(! WEIR_AND_COCKERHAM_FST == "NaN")

chr3_YmVsEtSml <- read.table("chr3_YmVsEtSml_Fst.weir.FST", header = TRUE, sep = "\t")
chr3_YmVsEtSml <- chr3_YmVsEtSml %>% filter(! WEIR_AND_COCKERHAM_FST == "NaN")

chr3_YmVsInd <- read.table("chr3_YmVsInd_Fst.weir.FST", header = TRUE, sep = "\t")
chr3_YmVsInd <- chr3_YmVsInd %>% filter(! WEIR_AND_COCKERHAM_FST == "NaN")

# Plotting Fst along the chromosome
chr2_IndVsEtSml_Fst_plot <- ggplot(data = chr2_IndVsEtSml, aes(x = POS, y = WEIR_AND_COCKERHAM_FST)) + 
  geom_point() +
  labs(x = "Position", y = "Fst value", title = "Chromosme 2 Pairwise Fst values between India and Ethiopian/Somliland populations")

chr2_YmVsEtSml_Fst_plot <- ggplot(data = chr2_YmVsEtSml, aes(x = POS, y = WEIR_AND_COCKERHAM_FST)) + 
  geom_point() +
  labs(x = "Position", y = "Fst value", title = "Chromosme 2 Pairwise Fst values between Yemen and Ethiopian/Somliland populations")

chr2_YmVsInd_Fst_plot <- ggplot(data = chr2_YmVsInd, aes(x = POS, y = WEIR_AND_COCKERHAM_FST)) + 
  geom_point() +
  labs(x = "Position", y = "Fst value", title = "Chromosme 2 Pairwise Fst values between Yemen and India populations")

chr3_IndVsEtSml_Fst_plot <- ggplot(data = chr3_IndVsEtSml, aes(x = POS, y = WEIR_AND_COCKERHAM_FST)) + 
  geom_point() +
  labs(x = "Position", y = "Fst value", title = "Chromosme 3 Pairwise Fst values between India and Ethiopian/Somliland populations")

chr3_YmVsEtSml_Fst_plot <- ggplot(data = chr3_YmVsEtSml, aes(x = POS, y = WEIR_AND_COCKERHAM_FST)) + 
  geom_point() +
  labs(x = "Position", y = "Fst value", title = "Chromosme 3 Pairwise Fst values between Yemen and Ethiopian/Somliland populations")

chr3_YmVsInd_Fst_plot <- ggplot(data = chr3_YmVsInd, aes(x = POS, y = WEIR_AND_COCKERHAM_FST)) + 
  geom_point() +
  labs(x = "Position", y = "Fst value", title = "Chromosme 3 Pairwise Fst values between Yemen and India populations")

# Generating the iamge containing the plot
png(filename = "Pairwise_Fst_Visuliaztions.png", width = 15, height = 10, res = 300, units = "in")
grid.arrange(chr2_IndVsEtSml_Fst_plot, chr2_YmVsEtSml_Fst_plot, chr2_YmVsInd_Fst_plot, chr3_IndVsEtSml_Fst_plot, chr3_YmVsEtSml_Fst_plot, chr3_YmVsInd_Fst_plot, ncol = 3)
dev.off()




