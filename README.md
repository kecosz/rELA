[![DOI](https://zenodo.org/badge/645960152.svg)](https://zenodo.org/badge/latestdoi/645960152)
# rELA
An R package for energy landscape analysis originally developed by Hiroaki Fujita ([hiroakif93](https://github.com/hiroakif93)). The latest version is 0.80.3.

## Notes:
### 0.81
- Implementing LDA algorithm in the preprocessing step based on Zhang and Nakaoka (2024, PLOS One). The Latent Dirichlet Allocation (LDA) model enables energy landscape analysis (ELA) to be performed in terms of microbiome assemblages, providing a more coarse-grained view of community state transitions.
- The tutorial for LDA preprocessing step is currently available in ([rELA_LDA_tutorial.ipynb](https://github.com/kecosz/rELA/blob/main/rELA_LDA_tutorial.ipynb)).
- Or users can manually load ([LDA.R](https://github.com/kecosz/rELA/blob/main/LDA.R)) and use with their preferred version and environment of ELA.

### 0.80
- The issues in 0.70 -0.73 were fixed. 
- Update in SA argorithm: Parameter for sparse-matrix is normalized by the number of species (matrix size), and fitting with more fixed parameters is now possible regardless of the number of species.
- Update in random parameter set generation: By running hb.params and HeatBath functions, species occurence matrix and environmental parameter matrix are randomly generated based on the known parameter sets (h,g, and J). Users freely can change the connectivity in species-species interactions.

#### 0.80.1
- Fix the error in runELA function. Modifying sstable and tptable.

#### 0.80.2
#### Fix the error in SSentropy, Stability, and gStability function.
- The new SSentropy, Stability, gStability functions can show whether all stable state searches successfully converged and display whether the configuration used is sufficient for the target dataset.

#### Disconnectivity Graph with interquartile range
- The SGD method usually produces deviations in the parameter estimation process.

- The new function, bootstrap_ELA, performs bootstrap sampling on a series of estimated parameter sets and computes the variability of the estimated energies among the predicted stable states and tipping points.

- The new showDG function considers variabilities in energies and displays a range as an IQR box plot for each stable state or tipping point.

#### 0.80.3
- The unexpected behaviour in the SA function section that stores intermediate results has been fixed.

### 0.7x
**IMPORTANT** We have discovered a critical flaw in versions 0.70–0.73. These versions have been removed and replaced with the alternative version (0.74).  

### 0.60
Due to the change in the method of early stopping, it is no longer necessary to set *qth* that is used as the criterion for stopping in SA and fullSA. In later versions, *qth* will be removed.

## What
Energy landscape analysis is a systematic method for analyzing an energy landscape represented as a weighted network (Fig. 1). In the energy landscape, the nodes of the network represent unique community compositions, and the links represent the transition paths between them. The community composition is described as a binary vector that represents the presence (1) and absence (0) of a species, and the links connect all nodes that differ only in the presence or absence of one species. The nodes are weighted by their energies, and the difference in energy level drives the direction of transitions in community composition. Transitions from high-energy states to low-energy states occur more frequently than vice versa. The energy is assigned by a pairwise maximum entropy model or its extension with an external force (environmental effect) term. The parameters of the model are estimated by matching the expected probability of community compositions given by the model to empirical probabilities calculated from the observed data. (For details of the method, see Suzuki et al. 2021.)  
  
![fig1](https://user-images.githubusercontent.com/60416241/131083532-de900019-f558-41c7-b37d-5595e4d5848a.png)
Figure 1. Illustrative explanation of our approach.

Reference: 
- Suzuki, K., Nakaoka, S., Fukuda, S., & Masuya, H. (2021). Energy landscape analysis elucidates the multistability of ecological communities across environmental gradients. Ecological Monographs, 91(3), e01469. https://esajournals.onlinelibrary.wiley.com/doi/abs/10.1002/ecm.1469

## How to run
### Prerequisits
- R 4.3
- Rcpp
- RcppArmadillo
- doParallel

### On Windows

### On MAC OS (Ventura 13)

Install Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install gcc - gfortran
```
brew install gcc
```
In Terminal:
```
touch ~/.R/Makevars
```

```
mkdir -p ~/.R   
```

```
vim ~/.R/Makevars
```

Add: 
```
FC      = /usr/local/bin/gfortran
F77     = /usr/local/bin/gfortran
FLIBS   = -L/usr/local/bin/gfortran/lib
```

In R Studio (R Version 4.3):
```
install.packages("Rcpp")
install.packages("RcppArmadillo")
install.packages("doParallel")
install.packages("rELA/rELA.v0.21.tar.gz", type = "source")
library("rELA")
```

### On Google Colab
See ipynb file

#### Use local runtime
Google Colab normally runs calculations on a virtual machine, but by following the steps below, you can use your local machine's computing resources.

1. Install Docker  
This is necessary if you have not installed Docker.  
https://docs.docker.com/engine/install/  
Please pay attention to the initial resource allocation settings and change them if necessary.

2. Create a working directory (can be omitted)  
Ex. `c:/mnt/rELA_test`  
(The data is also placed in the working directory like `c:/mnt/rELA_test/data/..`)

3. Start Google colab runtime (for the latest information see: https://research.google.com/colaboratory/local-runtimes.html)  
Execute the following command at the terminal:  

    ```
    docker run -v /c/mnt/rELA_test:/contents/rELA_test -p 127.0.0.1:8888:8080 us-docker.pkg.dev/colab-images/public/runtime
    ```
    - You can change “c/mnt/rELA_test” to match the location of your working directory  
    - On Windows, you need to include the volume label `c:` as the top-level folder  

    **After running, copy the token displayed at the end.**

5. Open the google colab notebook

6. Connect to local runtime  
Select `Connect to Local Runtime` in the upper right (`▼`) and paste the copied token after `token=` and click `Connect`.

7. Tips
    - You can read files in the mounted folder. When you write a file to the folder, it is reflected in the corresponding local (host-side) folder.
    - You can force the local runtime to close by selecting the terminal window and pressing `Ctrl+C Ctrl+C`.

