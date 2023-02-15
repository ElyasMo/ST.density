# ST.density
An R package to illustrates the spatial distribution of desired gene expression across ST spots in histology image of tissue section

## Install
devtools::install_github("https://github.com/ElyasMo/ST.density")

## Vignette

```r 
library(ST.Density)
# ST.object: the processed Seurat object
# Gene: Desired gene for investigation of the spatial distribution of expression
# Threshold: the ratio limit of the expression gene in each spot
# Path: the directory which contains the Spatial folder in output of SpaceRanger

ST.density(ST.object,Gene,Threshold,Path)
```
