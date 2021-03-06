meteoland - Landscape meteorology tools
================

<!-- badges: start -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/meteoland)](https://cran.r-project.org/package=meteoland)
[![](https://cranlogs.r-pkg.org/badges/meteoland)](https://cran.rstudio.com/web/packages/meteoland/index.html)
[![R-CMD-check](https://github.com/emf-creaf/meteoland/workflows/R-CMD-check/badge.svg)](https://github.com/emf-creaf/meteoland/actions)
<!-- badges: end -->

## Introduction

With the aim to assist research of climatic impacts on forests, the R
package `meteoland` provides utilities to estimate daily weather
variables at any position over complex terrains:

-   Spatial interpolation of daily weather records from meteorological
    stations.
-   Statistical correction of meteorological data series (e.g. from
    climate models).
-   Multisite and multivariate stochastic weather generation.

A more detailed introduction to the package functionality can be found
in De Cáceres et al. (2018).

## Package installation and documentation

Package `meteoland` can be found at [CRAN](https://cran.r-project.org/),
but the version in this repository may not be the most recent one.
Latest stable versions can be downloaded and installed from GitHub as
follows (package `devtools` should be installed first):

``` r
devtools::install_github("emf-creaf/meteoland")
```

Alternatively, users can have help to run package functions directly as
package vignettes, by forcing their inclusion in installation:

``` r
devtools::install_github("emf-creaf/meteoland", 
                         build_opts = c("--no-resave-data", "--no-manual"),
                         build_vignettes = TRUE)
```

Detailed documentation on `meteoland` calculation routines can be found
at (<https://emf-creaf.github.io/meteolandbook/index.html>).

## References

-   De Caceres M, Martin-StPaul N, Turco M, Cabon A, Granda V (2018)
    Estimating daily meteorological data and downscaling climate models
    over landscapes. Environmental Modelling and Software 108: 186-196.
    (<doi:10.1016/j.envsoft.2018.08.003>).
