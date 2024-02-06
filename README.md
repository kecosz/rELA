[![DOI](https://zenodo.org/badge/645960152.svg)](https://zenodo.org/badge/latestdoi/645960152)
# rELA
An R package for energy landscape analysis. The latest version is 0.46.

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

### On Google Colab
See ipynb file

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
