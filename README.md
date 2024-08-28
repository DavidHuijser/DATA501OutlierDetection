
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OutlierDetection

<!-- badges: start -->
<!-- badges: end -->

The goal of OutlierDetection is to dected Outliers.

## Installation

You can install the development version of OutlierDetection like so:

``` r
devtools::install_github("DavidHuijser/DATA501LSBETA")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(OutlierDetection)
slope <-  4
offset <- -3
sds <- 7
x <- seq(from = 1, to = 10, length.out= 100)

y <- slope*x + offset

# Add regular noise
noise <- rnorm(length(x),sd=2)
y <- y + noise

# generate number of outliers
num <- 3
s <- sample(length(x), num)
y[s] <- y[s] +  rnorm(num, sd=sds) + runif(num, -sds,sds)

# Create plot
df <- data.frame(x,y)
lin_model <- lm(y~x)


InfluenceMeasure(lin_model, measure="Cooks", output = "values")
#>   [1] 4.418277e-05 7.278091e-04 1.787433e-05 5.816767e-04 1.769886e-05
#>   [6] 3.326570e-03 1.651293e-02 6.406318e-03 7.253444e-03 2.473756e-02
#>  [11] 2.456270e-02 9.216360e-04 5.619909e-03 5.362858e-03 7.710746e-03
#>  [16] 2.525634e-03 1.148812e-02 1.750762e-02 8.574972e-04 2.127267e-03
#>  [21] 4.607909e-02 1.104528e-02 4.118456e-06 1.255924e-03 7.720941e-04
#>  [26] 4.090730e-03 1.197711e-05 2.150507e-02 3.548644e-03 4.920762e-03
#>  [31] 1.760103e-05 3.725615e-05 3.813336e-03 7.119177e-03 8.764935e-04
#>  [36] 3.633827e-05 2.698404e-02 5.703205e-04 3.071187e-03 2.122773e-03
#>  [41] 1.072649e-02 3.211314e-03 7.581542e-05 1.142450e-02 2.077134e-03
#>  [46] 1.237943e-02 3.025560e-03 7.850029e-05 1.155956e-05 3.532207e-04
#>  [51] 5.606294e-03 1.858917e-03 3.516872e-03 8.978185e-06 2.258517e-03
#>  [56] 8.701172e-03 1.272045e-03 6.563597e-06 2.866111e-04 1.051412e-02
#>  [61] 2.833921e-03 2.934137e-02 1.109446e-01 3.233989e-03 1.694442e-02
#>  [66] 5.281194e-03 3.308689e-03 4.523703e-03 3.771269e-03 5.447868e-03
#>  [71] 6.666068e-05 9.748650e-06 5.415910e-03 2.795839e-03 4.106269e-03
#>  [76] 4.317659e-04 4.288331e-03 4.584310e-03 5.300513e-03 1.176604e-02
#>  [81] 5.000447e-04 4.466706e-02 1.536313e-02 2.921118e-03 2.465024e-03
#>  [86] 1.562737e-01 1.659043e-02 1.584885e-03 1.632001e-04 6.660785e-04
#>  [91] 2.928062e-03 4.278762e-05 8.049139e-03 2.312175e-02 6.436903e-03
#>  [96] 8.197298e-03 7.209579e-03 7.062767e-03 5.813075e-03 1.275569e-02
InfluenceMeasure(lin_model, measure="Cooks", output = "plot")
```

<img src="man/figures/README-example-1.png" width="100%" />

<!--
You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.
&#10;You can also embed plots, for example:
&#10;<img src="man/figures/README-pressure-1.png" width="100%" />
&#10;In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN.
-->
