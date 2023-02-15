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

## Output
1- In order to decide which threshold is more accurate for your investigation, ST.density provides a VlnPlot which shows the distribution of ratio of desired gene across all occupied spots with tissue section.

![VlnPlot- Helps to determine the threasholds](https://github.com/ElyasMo/ST.density/blob/main/Figures/Vln.png)

*Helps to determine the threasholds*

2- Next, based on the determined threshold which was chosen in the first step, the spatial distribution of the selected gene which has a higher ratio of expression in each spot than the determined threshold is ilustrated.

![DensityPlot- Illustrates the spatial distribution of desired gene](https://github.com/ElyasMo/ST.density/blob/main/Figures/Density.png)

*Spatial distribution of desired gene*

