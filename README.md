# rELA
An R package for energy landscape analysis. The latest version is 0.42.
Thanks to Dr. Raphael M. Kronberg for his suggestion about using shorter strings for indicating stable states.  
  
### To run it on MAC OS Ventura 13

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
