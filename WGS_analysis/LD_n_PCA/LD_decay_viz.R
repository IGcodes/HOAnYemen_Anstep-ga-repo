# Setting working directory
setwd("C:/Users/aaisu/Box/Carter Lab/Projects/Anstep_GA_Yemen/BA_Phased_LD_12.13.2024")

rm(list = ls())

library(tidyverse)
library(gridExtra)

# set paths
YmEthInd_allChrs_bins <- "./YmEthInd_allChrs.ld_decay_bins"
YmEthInd_chrX_bins <- "./YmEthInd_ChrX.ld_decay_bins"
YmEthInd_chr2_bins <- "./YmEthInd_Chr2.ld_decay_bins"
YmEthInd_chr3_bins <- "./YmEthInd_Chr2.ld_decay_bins"

# read in data
YmEthInd_allChrs_ld_bins <- read_tsv(YmEthInd_allChrs_bins)
YmEthInd_chrX_ld_bins <- read_tsv(YmEthInd_chrX_bins)
YmEthInd_chr2_ld_bins <- read_tsv(YmEthInd_chr2_bins)
YmEthInd_chr3_ld_bins <- read_tsv(YmEthInd_chr3_bins)

# plot LD decay
YmEthInd_allChrs_LD_plot <- ggplot(YmEthInd_allChrs_ld_bins, aes(distance, avg_R2)) + 
  geom_point() + geom_smooth(method = "loess") +
  xlab("Distance (bp)") + 
  ylab(expression(italic(r)^2))+
  scale_x_continuous(breaks = seq(0, max(YmEthInd_allChrs_ld_bins$distance), by = 50000)) +
  ggtitle("All Chromosomes")
YmEthInd_ChrX_LD_plot <- ggplot(YmEthInd_chrX_ld_bins, aes(distance, avg_R2)) + 
  geom_point() + geom_smooth(method = "loess") +
  xlab("Distance (bp)") + 
  ylab(expression(italic(r)^2))+
  scale_x_continuous(breaks = seq(0, max(YmEthInd_chrX_ld_bins$distance), by = 50000)) +
  ggtitle("Chromosome X")
YmEthInd_Chr2_LD_plot <- ggplot(YmEthInd_chr2_ld_bins, aes(distance, avg_R2)) + 
  geom_point() + geom_smooth(method = "loess") + 
  xlab("Distance (bp)") + 
  ylab(expression(italic(r)^2))+
  scale_x_continuous(breaks = seq(0, max(YmEthInd_chrX_ld_bins$distance), by = 50000)) +
  ggtitle("Chromosome 2")
YmEthInd_Chr3_LD_plot <- ggplot(YmEthInd_chr3_ld_bins, aes(distance, avg_R2)) + 
  geom_point() + geom_smooth(method = "loess") + 
  xlab("Distance (bp)") + 
  ylab(expression(italic(r)^2))+
  scale_x_continuous(breaks = seq(0, max(YmEthInd_chrX_ld_bins$distance), by = 50000)) +
  ggtitle("Chromosome 3")

# Saving plots in one figure
png(filename = "LD_decay_by_distance.png", width = 15, height = 10, units = "in", res = 300)
# Arrange six plots in a 2x3 grid
grid.arrange(YmEthInd_allChrs_LD_plot, YmEthInd_ChrX_LD_plot, YmEthInd_Chr2_LD_plot, YmEthInd_Chr3_LD_plot, ncol = 1, nrow = 4)
dev.off()
