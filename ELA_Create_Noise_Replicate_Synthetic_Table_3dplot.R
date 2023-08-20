unavailable <- setdiff(c("Rcpp","RcppArmadillo","doParallel","tidyverse",'gsubfn', 'zoo','snow','plyr', 'gtools','ggsci','igraph', 'tidygraph','RColorBrewer',"stringdist", "dplyr"), rownames(installed.packages()))
install.packages(unavailable)

# install rELA package
# install.packages("Rcpp")
# install.packages("RcppArmadillo")
# install.packages("doParallel")
# install.packages("rELA/rELA.v0.42.tar.gz", type = "source")

library("Rcpp")
library("RcppArmadillo")
library("doParallel")
library('tidyverse')
library('gsubfn')
library('zoo')
library('snow')
library('plyr')
library('gtools')
library('ggsci')
library('igraph')
library('tidygraph')
library('RColorBrewer')
library("stringdist")
library("rELA")
library("dplyr")

## Energy Landscape Analysis

## Energy Landscape Analysis

### Download data

threshold = 0.00
threshold_interact = 0.0
threads = 10
pruning_pars = c(0.01, 0.01, 0.99)

# Specify the path for your own data in the code below, if necessary.
baseabtable <- read.csv("data/qbt_experiments/custom_abundance.csv", sep=',', fileEncoding='utf-8') %>%
  column_to_rownames(., var = "X")
baseabtable <-   subset(baseabtable, select =1:20)
basemetadata <- read.csv("data/qbt_experiments/custom_abundance.csv", sep=',', fileEncoding='utf-8') %>%
  column_to_rownames(., var = "X")
basemetadata <-   subset(basemetadata, select =21:22)
basemetadata <- head(basemetadata, 146)
head(baseabtable, 7)

head(basemetadata, 7)


# To group species with the same presence/absence pattern into one group,
#set grouping to 1 and specify a number between 0 and 1 for grouping_th.
# If 0, only species with the same presence/absence pattern will be grouped together.
list[ocmat, abmat, enmat, samplelabel, specieslabel, factorlabel] <-Formatting(baseabtable,basemetadata, normalizeq=1, parameters=pruning_pars, grouping=1, grouping_th=0.)

### Parameter fitting
#runSA: ocmatrix, env (environmental parameters; with>SA / without>fullSA), qth (threshold for stopping computation), rep (number of fitting processes to compute mean parameter value), threads (number of parallel threads)

sa <- runSA(ocmat=as.matrix(ocmat), qth=10^-5, rep=128, threads=10)

list[he,je,ge,hge] <- sa2params(sa)
he
hge


### Analysis and visualization of energy landscape
#### ELA function
elanp <- ELA(sa, env=NULL,
             SS.itr=20000, FindingTip.itr=10000, # <- the number of steps for finding stable states and tipping points (basically no need to change)
             threads=threads, reporting=TRUE)
#### ELA Pruning
ela <- ELPruning(elanp, th=threshold, threads=threads)

print( ela[[2]]) 
list[stablestates, stablen, tippingpoints, tippingen] <- ela[[1]]

### Stable states
stablestates

### Tipping 
tippingpoints

### Convert an integer representing a stable state (ssid) to a binary vector
# ssid -> binary vector
bin = as.list(lapply(stablestates, function(x){id2bin(x, ncol(ocmat))}))
names(bin) <- stablestates
bin

### Convert a binary vector to a ssid
# binary vector -> ssid
as.vector(sapply(bin, bin2id))

### Table of SSID, Energy, Community composition
colnames(ocmat)


sstable <- as.data.frame(cbind(stablestates, stablen, t(as.data.frame(bin)))) %>%
  'colnames<-'(c('ID', 'Energy', colnames(ocmat))) %>%
  'rownames<-'(1: length(stablestates))
sstable

### ID and energy of tipping points
as.data.frame(tippingpoints)

as.data.frame(tippingen)

### Energy of any community composition
cEnergy(ocmat[1,], he, je)

### Find the stable state for a community composition
Bi(ocmat[1,], he, je)

###############################################################################
# create the table for the 3d plots
###############################################################################

# Calculate dim reduction to project the community composition into the 3d plot

# replace with mds plot
adv = PCplot(ocmat, sa, ssrep=ela[[2]], pruned=FALSE, export = TRUE)
dim(adv)
print(adv)

# Calculate the Energy for each community composition
result <- apply(ocmat, 1, function(row) cEnergy(row, he, je))

# Calculate the  stable state for each community composition
ss_c <- apply(ocmat, 1, function(row) Bi(row, he, je)[[1]])
ss_c1 <- apply(ocmat, 1, function(row) Bi(row, he, je)[[2]])

row_names <- rownames(ocmat) # Assuming row names are set in ocmat

# Combine the results to a dataframe
result_df <- data.frame(time = row_names, Energy = result, rel.MDS1=adv$PC1, rel.MDS2=adv$PC2,TargetStableState=ss_c,TargetStableStateEn=ss_c1 )
dim(result_df)


###############################################################################
#### To reproduce the plot we need 8 replicata of each point
###############################################################################

# Create a function to replicate rows
replicate_rows <- function(data, n) {
  bind_rows(lapply(1:n, function(i) data))
}

# Define the number of replicates
num_replicates <- 8

# Group by 'id' and replicate rows within each group
final_df <- result_df %>%
  group_by(time) %>%
  do(replicate_rows(., num_replicates)) %>%
  mutate(replicate.id = ifelse(row_number() == 1, 1, row_number()))

# Print the final data frame
print(final_df)

noise_sd <- 0.05

# Function to add Gaussian noise
add_noise <- function(x) {x + rnorm(length(x), mean = 0, sd = noise_sd)}

# Apply noise to specific columns and replicate rows
### attention here we use PCA instead od MDS
noisy_final_df <- final_df %>%
  mutate(across(c(Energy, rel.MDS1, rel.MDS2), ~ add_noise(.))) %>%
  arrange(time, replicate.id)

# Print the final noisy data frame
print(noisy_final_df)

# Save the noisy_final_df data frame to a CSV file
csv_file_path <- "data/qbt_experiments/onw_table.csv"
write.csv(noisy_final_df, file = csv_file_path, row.names = FALSE, quote = FALSE)


# Print a message indicating the file has been saved
cat("Data frame saved to", csv_file_path, "\n")