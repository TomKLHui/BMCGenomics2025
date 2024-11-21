library(DESeq2)
library(tidyverse)
library(patchwork)
library(ashr)
library(pairwiseAdonis)
library(vegan)

run_deseq=function(f,metadata,condno=1,ref=F){
  dds = DESeqDataSetFromMatrix(countData = f, colData = metadata, design=as.formula(paste("~",colnames(metadata)[condno])))
  keep = rowSums(counts(dds)) >= 10
  dds = dds[keep,]
  dds[[condno]] <- droplevels(dds[[condno]])
  if (ref==T){
    dds <- estimateSizeFactors(dds, controlGenes=rownames(dds) %in% USiCGs)  
  }
  dds2=DESeq(dds)
  return(list(dds=dds,result=dds2,resultnames=resultsNames(dds2)))
}




plot_MA=function(dds2,annot,speciesname){
  res1.2=lfcShrink(dds2,contrast = c("condition","fish","control"), type= "ashr")
  res1.3=lfcShrink(dds2,contrast = c("condition","mix","control"), type= "ashr")
  res1.4=lfcShrink(dds2,contrast = c("condition","wild","control"), type= "ashr")
  res2.3=lfcShrink(dds2,contrast = c("condition","mix","fish"), type= "ashr")
  res1.2DF=as.data.frame(res1.2)%>%rownames_to_column(.,var = "transcript")%>% left_join(.,annot)
  res1.2DF$comparison="Fish-Control"
  res1.2DF$significant=ifelse(res1.2DF$padj < .05, "Significant", NA)
  res1.3DF=as.data.frame(res1.3)%>%rownames_to_column(.,var = "transcript")%>% left_join(.,annot)
  res1.3DF$comparison="Mix-Control"
  res1.3DF$significant=ifelse(res1.3DF$padj < .05, "Significant", NA)
  res1.4DF=as.data.frame(res1.4)%>%rownames_to_column(.,var = "transcript")%>% left_join(.,annot)
  res1.4DF$comparison="Wild-Control"
  res1.4DF$significant=ifelse(res1.4DF$padj < .05, "Significant", NA)
  res2.3DF=as.data.frame(res2.3)%>%rownames_to_column(.,var = "transcript")%>% left_join(.,annot)
  res2.3DF$comparison="Mix-Fish"
  res2.3DF$significant=ifelse(res2.3DF$padj < .05, "Significant", NA)
  allDF=rbind(res1.2DF,res1.3DF,res1.4DF,res2.3DF)
  allDF$species=speciesname
  lignoDF=allDF%>% filter(.,cazy%in% genes.c$Family|k %in% genes.k$KO)
  
  ma1.2=ggplot(res1.2DF, aes(baseMean, log2FoldChange, colour=significant)) + geom_point(size=1) + scale_y_continuous(limits=c(-3, 3), oob=squish) + scale_x_log10() + geom_hline(yintercept = 0, colour="tomato1", size=0.5) + labs(x="mean of normalized counts", y="log fold change")  + theme_bw()
  ma1.3=ggplot(res1.3DF, aes(baseMean, log2FoldChange, colour=significant)) + geom_point(size=1) + scale_y_continuous(limits=c(-3, 3), oob=squish) + scale_x_log10() + geom_hline(yintercept = 0, colour="tomato1", size=0.5) + labs(x="mean of normalized counts", y="log fold change")  + theme_bw()
  ma1.4=ggplot(res1.4DF, aes(baseMean, log2FoldChange, colour=significant)) + geom_point(size=1) + scale_y_continuous(limits=c(-3, 3), oob=squish) + scale_x_log10() + geom_hline(yintercept = 0, colour="tomato1", size=0.5) + labs(x="mean of normalized counts", y="log fold change")  + theme_bw()
  ma2.3=ggplot(res2.3DF, aes(baseMean, log2FoldChange, colour=significant)) + geom_point(size=1) + scale_y_continuous(limits=c(-3, 3), oob=squish) + scale_x_log10() + geom_hline(yintercept = 0, colour="tomato1", size=0.5) + labs(x="mean of normalized counts", y="log fold change")  + theme_bw()
  
  return(list(allDF=allDF,
              lignoDF=lignoDF,
              MAplot=list(ma1.2=ma1.2,ma1.3=ma1.3,ma1.4=ma1.4,ma2.3=ma2.3))
  )
}
ggsave()


plothistogram=function(dds2,annot_ligno){
resDF=as.data.frame(lfcShrink(dds2,contrast = c("condition","mix","fish"), type= "ashr"))
resDF$ligno <- ifelse(rownames(resDF)%in% annot_ligno, "ligno", NA)
resDF %>% filter(ligno=="ligno") %>% select(baseMean) -> resDF_ligno
resDF %>% select(baseMean)-> resDF_all
resDF_ligno$Gene="ligno"
resDF_all$Gene="all"
resDF_genecount<- rbind(resDF_ligno,resDF_all)
ggplot(resDF_genecount,aes(log10(baseMean),fill=Gene))+
    geom_histogram(alpha = 0.5)+scale_y_log10()+annotation_logticks() -> resDF_histogram
return(resDF_histogram)
}


my_colour = list(status=c("fish"="#F8766D","mix"="#7CAE00","control"="#00BFC4","wild"="#C77CFF"))
my_colour = list(status=c("OP1"="#66C2A5","PB1"="#A6D854","MF1"="#8DA0CB","HT1"="#E78AC3","TD1","#FC8D62"))

run_deseq_visualize = function(dds2,goi=c(""),condsp,metadata){
  #normalized abundances
  vst <- varianceStabilizingTransformation(dds2,blind=FALSE)
  vst.t = t(assay(vst)) 
  if(length(goi)>1){
    vst.t = vst.t[,colnames(vst.t)%in% goi]
  }
  #PCA
  pca = prcomp(vst.t)
  pc1.deseq <- round(pca$sdev[1]^2/sum(pca$sdev^2),2)
  pc2.deseq <- round(pca$sdev[2]^2/sum(pca$sdev^2),2)
  xlab.deseq <- paste("PC1: ", pc1.deseq, sep="")
  ylab.deseq <- paste("PC2: ", pc2.deseq, sep="")
  en.deseq = envfit(pca,vst.t, permutations = 999, na.rm = TRUE)
  scores.deseq <- as.data.frame(scores(pca$x))
  loadings.deseq <- as.data.frame(pca$rotation) 
  en_coord_cont.deseq = as.data.frame(scores(en.deseq, "vectors")) * ordiArrowMul(en.deseq,fill = scores.deseq$PC1)
  speciescol=scores.deseq$speciescol=condsp
  gg.deseq = ggplot(data = scores.deseq, aes(x = PC1, y = PC2)) + 
    geom_point(data = scores.deseq, aes(colour = speciescol), size = 3, alpha = 1) + 
    theme_minimal()+
    theme(axis.title = element_text(size = 10, face = "bold", colour = "grey30"),    
          panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey30"), 
          axis.ticks = element_blank(), axis.text = element_blank(), legend.key = element_blank(), 
          legend.title = element_text(size = 10, face = "bold", colour = "grey30"), 
          legend.text = element_text(size = 9, colour = "grey30"))
  gg.deseq+scale_color_manual(values=my_colour$status)+scale_fill_manual(values=my_colour$status)+xlab(xlab.deseq)+ylab(ylab.deseq)+ labs(fill='Feeding satatus') ->gg.deseq
  gg.deseq
  
  #sample distances
  sampleDists <-  vegdist(vst.t,method="euclidean")
  clustergene <- hclust(sampleDists, method="average")
  sampleDistMatrix <- as.matrix(sampleDists)
  rownames(sampleDistMatrix) <- rownames(metadata)
  colnames(sampleDistMatrix) <- NULL
  deseq.div.pair <- pairwise.adonis(sampleDists,metadata[,2],p.adjust.m = 'fdr')
  
  #deseq.sample2geneheatmap <- pheatmap(as.data.frame(vst.t),cluster_rows = FALSE,cluster_cols = TRUE,border_color = NA,annotation_legend = T,show_colnames = F)
  
  #dendrogram
  # using dendrapply
  #clusDendro = dendrapply(as.dendrogram(hclust(sampleDists)), colLab)
  #dendroplot = plot(clusDendro, main="Aitchison distance, Ward.D2 Cluster")
  return(list(pca=gg.deseq,stats=deseq.div.pair,raw=list(scores=scores.deseq,speciescol=condsp,xlab=xlab.deseq,ylab=ylab.deseq),vst.t=vst.t))
}
OP1_annot_ligno %>% filter(cazy %in% genes.c$Family) %>% .$transcript %>% run_deseq_visualize(OP1_deseq$result,.,OP1_metadata$condition,OP1_metadata) -> OP1_pca$cazy

2^(pca_cazy$vst.t) %>% .[,colMeans(.)>1000] %>% log2(.) %>% pheatmap(breaks = seq(8, 20, length.out = 100))
2^(pca_k$vst.t) %>% .[,colMeans(.)>1000] %>% log2(.) %>% pheatmap(breaks = seq(8, 20, length.out = 100))