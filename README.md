## Comparative transcriptomic analysis on endogenous lignocellulolytic capacity across mangrove crab species of different dietary preferences

## Abstract
**Background:**
Mangrove herbivorous sesarmid (MHS) crabs are the dominant primary consumer of mangrove litterfall. Previous studies either surveyed the expression profile of lignocellulases or compared the expression changes of specific endoglucanase and beta-glucosidases in response to change in diet. This study aims to generate a comprehensive expression profile that captures the representative highly expressed enzymes, differentially expressed enzymes in response to presence of lignocellulose, and inter-specific comparisons on the enzyme relative expressions responsible for the adaptation of herbivorous crabsMHS.
**Results:**
The crab transcriptomes of the five crab species have covered a total of 86 CAZy families and 26 KOs related to lignocellulose degradation, covering cellulose backbone and oligosaccharide degradation, and partial degradation of hemicellulose, pectin, and lignin in the transcriptomes of five crab species, with in which 52 CAZy families and nine KO were differentially expressed in response to different dietary lignocellulose content. Crabs that adopt herbivorous, omnivorous and carnivorous diets all exhibited changes in the expression of lignocellulose degrading genes with respect to the proportion of lignocellulose content in diet, but innate differences between species of different diet were much more drastic, with substantially higher relative expression levels of endoglucanases, hemicellulase and laccase in herbivorous crabsMHS crabs O. patshuni and P. continentale. 
**Conclusions:**
This demonstrated the plasticity in lignocellulose gene expression of crabs irrespective to their dietary habit, and drastic innate capacity for mangrove herbivorous crabs MHS to efficiently digest lignocellulose. With complementary actions from symbiotic gut microbiome, these features enabled the herbivorous sesarmid crab MHS to successfully adapt to terrestrial environments by sustaining carbohydrates nutrition on recalcitrant mangrove leaves and at the same time contribute to the nutrient recycling in the mangrove forest.

**Citation:** 

## Brief summary of bioinformatic methods
Adapter sequences, duplications, and reads of quality below Q20 were trimmed using Trim Galore! v0.22.0, and assessed the quality by FastQC v0.11.9 and MultiQC v1.13. De novo transcriptome assembly was done using Trinity v2.14.0 and further cleaned of internal adapters using NCBI Foreign Contamination Screening program suite v0.5.4 and removed short contigs using bbmap v39.01. isoforms were clustered using CD-HIT-EST v4.8.1 with similarity threshold of 0.9. Quality of assembly were assessed by transrate v1.0.3 [33] ,BUSCO v5.4.4 [34] with arthropoda_odb10 (version 2020-09-10), and TrinityStats. protein-coding regions were extracted using TransDecoder v5.5.0, annotated to databases using HMMER v3.1b2 and DIAMOND v2.0.15. UniProtKB_SwissProt (release 2022-03), Pfam 34.0 , NCBI non redundant (nr) protein database (release 243), Kyoto Encyclopedia of Genes and Genomes (KEGG) (release v58), and CAZy database (release V10, 07292021) were used for Gene Ontology (GO) annotations and protein functional annotations. Signal peptide prediction was done using signalP v6.0. All annotation were summarized by Trinotate v3.2.2 and have mapped to read count at gene-level generated by RSEM.

The gene count data were imported to R Studio v.4.1.0 for DESeq analyses, and uploaded to GSEA website. GSEA results were then read back to R for visualizations.

## Data structure
**Species abbreviations:**
OP=Orisarma patshuni;PB=Parasesarma continentale (formerly part of Parasesarma bidens);MF=Metopograpsus frontalis;HT=Hemigrapsus takanoi;TD=Thranita danae

|-/match_lists (Gene name annotation mapping to IDs)
| |-cazy2name
| |-go2name
| |-go_annot
| |-k2ko
| |-k2name
| |-ko2name
| |-funlist.c.subfam
| |-funlist.k.
|
|-/sample_filenames (Metadata for sample names for each species)
| |-samples[$Species].rna.txt
|
|-[0-1][0-9][a-h].[$scriptname].(sh,R,py,pl) (workflow scripts)
|
|-README.md

## Related research
Lee, C. Y., & Lee, S. Y. (2024). Contribution of aerobic cellulolytic gut bacteria to cellulose digestion in fifteen coastal grapsoid crabs underpins potential for mineralization of mangrove production. _Current Microbiology_, 81(8), 224. https://doi.org/10.1007/s00284-024-03718-5

Hui, T.K.L., Lo, I.C.N., Wong, K.K.W., Tsang, C. T. T., & Tsang, L. M. (2024). Metagenomic analysis of gut microbiome illuminates the mechanisms and evolution of lignocellulose degradation in mangrove herbivorous crabs. _BMC Microbiology_, 24, 57. https://doi.org/10.1186/s12866-024-03209-4

Tsang, C. T. T., Hui, T. K. L., Chung, N. M., Yuen, W. T., & Tsang, L. M. (2024). Comparative analysis of gut microbiome of mangrove brachyuran crabs revealed patterns of phylosymbiosis and codiversification. Molecular Ecology, 33(12), e17377. https://doi.org/10.1111/mec.17377