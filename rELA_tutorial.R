unavailable <- setdiff(c("Rcpp","RcppArmadillo","doParallel","tidyverse",'gsubfn', 'zoo','snow','plyr', 'gtools','ggsci','igraph', 'tidygraph','RColorBrewer'), rownames(installed.packages()))
install.packages(unavailable)

# install rELA package
# install.packages("Rcpp")
# install.packages("RcppArmadillo")
# install.packages("doParallel")
# install.packages("rELA/rELA.v0.21.tar.gz", type = "source")

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
library("rELA")

# Specify the path for your own data in the code below, if necessary.
baseabtable <- read.csv('rELA/data/abundance_table.csv', sep=',', fileEncoding='utf-8') %>%
  column_to_rownames(., var = "X")
basemetadata <- read.csv('rELA//data/sample_metadata.csv', sep=',', fileEncoding='utf-8') %>%
  column_to_rownames(., var = "X")

head(baseabtable, 7)

head(basemetadata, 7)

# formating the data
list[ocvecs, abvecs, envecs, samplelabel, specieslabel, factorlabel] <- Formatting(baseabtable, basemetadata, 0, c(0.05, 0.05, 0.95))

# look at the ocvecs
ocvecs

#runSA: ocmatrix, env (environmental parameters; with>SA / without>fullSA), qth (threshold for stopping computation), rep (number of fitting processes to compute mean parameter value), threads (number of parallel threads)

sa <- runSA(data=as.matrix(ocvecs), qth=10^-5, rep=256, threads=1)

# extract the values for the likelihood estimates
list[he,je,ge,hge] <- sa2params(sa)


elanp <- ELA(sa, env=NULL,
                SS.itr=20000, FindingTip.itr=10000, # <- the number of steps for finding stable states and tipping points (basically no need to change)
                threads=1, reporting=TRUE)
ela <- ELPruning(elanp, th=0.08)

# extract the parameters
list[stablestates, stablen, tippingpoints, tippingen] <- ela[[1]]


# ssid -> binary vector
bin = as.list(sapply(stablestates, function(x){CIntegerDigits(x, length(colnames(ocvecs)))}))
bin

# binary vector -> ssid
as.vector(sapply(bin, function(x){str2i(paste(unlist(applyvec(x, as.character)), collapse=''))}))


sstable <- as.data.frame(cbind(stablestates, stablen, t(as.data.frame(bin)))) %>%
  'colnames<-'(c('ID', 'Energy', colnames(ocvecs))) %>%
  'rownames<-'(1: length(stablestates))
sstable

#write the stable states to a csv file
write.csv(x = sstable, file="tables/sstable.csv")


# ID and energy of tipping points
# look at the tippings points
as.data.frame(tippingpoints)

as.data.frame(tippingen)

# Energy of any community composition
x <- replace(rep(0,length(ocvecs[1,])),10,1)
# calculate the energy given the MLEs
cEnergy(x, he, je)

# Energy of any community composition
x <- replace(rep(0,length(ocvecs[1,])),10,1)
Bi(x, he, je)

# Principal component analysis
# Observed community compositions plotted on a PC1,2 plane and color-coded by their stable states
PCplot(ocvecs, sa, ssrep=ela[[2]])
PCplot(ocvecs, sa, ssrep=ela[[2]], pruned=FALSE)

# Disconnectivity graph
showDG(ela[[1]], ocvecs, "test")

# Visualization of species’ interaction
showIntrGraph(ela[[1]], je, th=0.4, # <- Threshold for links to be displayed
              annot_adj=c(0.75, 2.00))

# Energy landscape analysis with environmental gradient
sa2 <- runSA(data=as.matrix(ocvecs), env=as.matrix(envecs), qth=10^-5, rep=256, threads=1)

colnames(envecs)

gela <- GradELA(sa=sa2, eid="factor.1", # Specify the label or position of an environmental factor
  env=envecs, refenv=NULL, steps=32, prn=0.05, threads=1) #[[1]]: return value of ELA function for each step, [[2]]: value of environmental factor for each step, [[3]]: specified environmental factor

# Disconnectivity graph
showDG(gela[[1]][[1]][[1]], ocvecs)

# SSentropy and energy gap
showSSD(gela)

stability(sa, unique(ocvecs))