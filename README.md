[![DOI](https://zenodo.org/badge/645960152.svg)](https://zenodo.org/badge/latestdoi/645960152)
# rELA
An R package for energy landscape analysis. The latest version is 0.52.

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

