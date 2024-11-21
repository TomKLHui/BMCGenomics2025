function(f,metadata,condno=1,ref=F){
  dds = DESeqDataSetFromMatrix(countData = f, colData = metadata, design=as.formula(paste("~",colnames(metadata)[condno])))
  keep = rowSums(counts(dds)) >= 10
  dds = dds[keep,]
  dds[[condno]] <- droplevels(dds[[condno]])
  if (ref==T){
    dds <- estimateSizeFactors(dds, controlGenes=rownames(dds) %in% USiCGs)  
  }
  dds2=DESeq(dds,betaPrior = TRUE)
  return(list(dds=dds,result=dds2,resultnames=resultsNames(dds2)))
}

deseq_control_cazy=run_deseq(cazy_control,metadata_control,condno = 2)
deseq_control_k=run_deseq(k_control,metadata_control,condno = 2)

results(deseq_control_cazy$result,contrast = c("species","OP1","PB1"))%>%as.data.frame() %>% filter(padj<0.05)->results_control_cazy_all_OP1PB1
results_control_cazy_all_OP1PB1 %>% .[rownames(.)%in%genes.c$Family,]%>% exportTable(.,"by_species/control_cazy_OP1PB1.txt")

#get all count
deseq_cazy$result %>% varianceStabilizingTransformation() %>% assay() %>%as.data.frame-> cazy_vst

#filter out gene families <1000
2^cazy_vst %>% filter(rowMeans(.)>1024) %>% .[rownames(.) %in% genes.c$Family,]%>% log2(.) %>% pheatmap(border_color = NA,breaks = seq(min(.),19,length.out=100),cluster_cols = F)
2^k_vst %>% filter(rowMeans(.)>1024) %>% .[rownames(.) %in% genes.k$KO,]%>% log2(.) %>% pheatmap(border_color = NA,breaks = seq(min(.),19,length.out=100),cluster_cols = F)

#grep genes with >1000
TD1_deseq$result %>% varianceStabilizingTransformation() %>% assay() %>% as.data.frame %>% filter(.,rowMeans(2^.)>1000) %>%rownames_to_column(.,var = "transcript")%>% left_join(.,TD1_annot,by="transcript") %>% select(c("transcript","cazy","k"))%>% exportTable(.,"TD1.1000count.txt")