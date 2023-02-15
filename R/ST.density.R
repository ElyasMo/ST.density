
#' Illustrate the spatial distribution of gene expression
#'
#' The package requires four parameters including a) processed Seurat object, b) desired gene 
#' c) Ratio threshold for the expression of gene in each spot d) Path to the Spatial folder in
#'  SpaceRanger output directory. As a results, it illustrates the spatial distribution of desired gene 
#'  in tissue section as a density plot.
#'
#' @param ST.object Seurat object which was pre-processed and the dimentionality reduction has been done
#' @param Gene The desired gene to investigate the spatial distribution
#' @param Threshold The limit ratio that you would like to apply to see the spots with expression higher than this threshold
#' @param Path Path to the Spatial folder in output directory of SpaceRanger which contains the coordination in CSV format
#' @return A density ggplot illustration of the spatial distribution of gene expression
#' @export
ST.density <- function(ST.object,Gene,Threshold,Path){
  if ("SCT" %in% names(ST.object@assays)) {
    AD_gene <- match(Gene,rownames(ST.object@assays$SCT))
    AD_genes <- rownames(ST.object@assays$SCT)[AD_gene]
  } else {
    AD_gene <- match(Gene,rownames(ST.object@assays$Spatial))
    AD_genes <- rownames(ST.object@assays$Spatial)[AD_gene]
  }
  
  AD_genes <- AD_genes[!is.na(AD_genes)]
  ST.object[["percent.AD"]]<-PercentageFeatureSet(ST.object,features=AD_genes)
  
  ##A good estimation for the thresholds
  ##Box plot may help to decide about the thresholds
  df <- data.frame(Ratio = ST.object@meta.data$percent.AD,
                   Gene=rep(Gene,length(ST.object@meta.data$percent.AD)))
  
  print(ggplot(df, aes(x=Gene, y=Ratio)) +
          geom_violin(trim=FALSE, fill='#A4A4A4', color="darkred")+
          geom_boxplot(width=0.1) + theme_minimal())
  
  
  # Adding the coordinates
  ## The metadata is filtered and we would like to see the locations which have the accumulated spots with high percentage of determined genes
  
  ##inserting the coordinators from spatial directory of SpaceRanger output
  ST.object_spatial <- read.csv(paste0(Path,"/tissue_positions_list.csv"), row.names=1)
  names(ST.object_spatial) <- c("in tissue","row","col","pxl.row", "pxl.col")
  ##Adding cordinates to the metadata
  ST.object_meta <- cbind(ST.object@meta.data[intersect(rownames(ST.object@meta.data), rownames(ST.object_spatial)),], ST.object_spatial[intersect(rownames(ST.object@meta.data), rownames(ST.object_spatial)),])
  
  
  ##Background
  ST.object_back <- ST.object
  ST.object_meta_back <- cbind(ST.object_back@meta.data[intersect(rownames(ST.object_back@meta.data), rownames(ST.object_spatial)),], ST.object_spatial[intersect(rownames(ST.object_back@meta.data), rownames(ST.object_spatial)),])
  
  ST.object_meta_THR1 <- subset(ST.object_meta, subset =  percent.AD > Threshold)
  
  
  p1 <- ggplot()+  
    stat_density_2d(aes(ST.object_meta_back$col,-(ST.object_meta_back$row)), 
                    geom = "point", colour="light grey",contour_var = "count",h=1, n=200)+
    stat_density_2d(aes(ST.object_meta_THR1$col,-(ST.object_meta_THR1$row) , fill = (stat(nlevel))*(length(ST.object_meta_THR1$row))), 
                    geom = "polygon",contour = T, n=100)+
    scale_fill_gradientn(colors = c(NA, NA, NA,NA,plasma(7)))+
    labs(x= "x", y = "y")+
    xlim(-30, 180)+
    ylim(-90, 20)+
    theme_classic()+ggtitle(paste0("Thereshold = ",Threshold, "\nNumber of spots = ", as.character(length(ST.object_meta_THR1$row)))) 
  
  p1$labels$fill <- "Density"
  print(p1)
}