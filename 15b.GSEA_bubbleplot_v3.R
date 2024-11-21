library(tidyverse)
library(data.table)
library(rebus)
library(tidytable)
library(pheatmap)
library(gridExtra)
library(RColorBrewer)
library(DESeq2)
library(ggtext)
#
closeAllConnections()
rm(list=ls())
#
setwd("C:/Users/wkwka/Documents/Manuscript Prep/202309_Crab HP Transcriptome MS/20240202 plots update")
load("GSEA_plots.RData")
load("smp_data.RData")
#
# ====== A CAZY =====
# cazy annot ====
cazy_selRows <- GSEA_cazy_subset$NAME %>% unique()
cazy_annot <- genes.c %>% filter(Family %in% cazy_selRows) %>% mutate(order = 1:nrow(.)) %>% 
  group_by(Substrate) %>% mutate(x = mean(order))
#
GSEA_cazy_subset$NAME <- factor(GSEA_cazy_subset$NAME, levels = cazy_annot$Family)
GSEA_cazy_subset$comparison <- factor(GSEA_cazy_subset$comparison,
                                      levels=c("Fish vs Control", "Mix vs Control","Mix vs Fish","Wild vs Control"))
# cazy plot ==== 
bubble_grid_plot_a <- 
  GSEA_cazy_subset %>% left_join(smp_tbl %>% select(species, label, condition, mean_y) %>% unique(), by = "species") %>%
  ggplot(aes(y=label, x=NAME))+
  facet_grid(comparison~Substrate, scales = "free", space = "free", switch = "x")+
  geom_point(aes(fill = -NES, size = SIZE, color = -NES), shape = 21) +
  theme_bw() +
  theme(
    plot.margin=unit(c(0.5,0.2,0,0.2), 'cm'),
    panel.border = element_rect(color = "grey60"),
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(angle = -90, hjust = 0, size = 7, color = "black"),
    axis.text.y = element_text(face = "italic", size = 6, color = c("#4D9221","#4D9221",
                                                                     "#08519C","#08519C","#BD0026") %>% rev()),
    strip.background.y = element_blank(),
    strip.text.x = element_text(size = 8, face = "bold"),
    strip.text.y = element_text(size = 8, face = "bold"),
    legend.position = 'bottom',
    legend.text = element_text(size = 6),
    legend.title = element_text(size = 8, face = "bold", hjust = 100),
    legend.background = element_rect(fill = "transparent"),
    legend.box.background = element_rect(color = "grey80"),
    legend.box.spacing = unit(0.1, "cm"),
    text = element_text(color = 'black'),
    plot.title = element_text(size = 8, face = "bold", hjust = 0.5)
  ) + ggtitle("CAZY") +
  guides(
    col = guide_none(),
    size = guide_legend("Gene size", title.hjust = 0),
    fill = guide_colorsteps(
      barheight = unit(0.3, 'cm'),
      barwidth = unit(2, 'cm')
      )
  ) +
  scale_size_area(max_size = 5) +
  scale_fill_viridis_c(
    labels = scales::label_number_auto(),
    na.value = 'grey80'
  ) +
  scale_color_viridis_c(
    labels = scales::label_number_auto(),
    na.value = 'grey80'
  ) +
  labs(fill = 'NES')+
  geom_text( 
    aes(label = FDR.q.val), 
    nudge_x = 0.18, 
    nudge_y = 0.05, hjust = 0, vjust = 0, size = 3,
    col = 'brown3'
  ) 
#
# ====== B K KO GO =====
# group k, ko, go annot ====
k_selRows <- GSEA_k_subset$NAME %>% unique()
k_annot <- genes.k %>% filter(NAME %in% k_selRows) %>% mutate(LABEL = NAME, order = 1:nrow(.), GROUP = "KO") %>% 
  select(NAME, LABEL, order, GROUP)
#
kegg_selRows <- GSEA_ko_subset$NAME %>% unique()
kegg_annot <- ko2name %>% mutate(NAME = str_replace_all(KEGG_ko, "ko", "KO"), 
                                 ko_name = str_replace_all(ko_name, "\\[", "_")) %>% 
  mutate(ko_name = str_split_i(ko_name,"_",1)) %>%
  filter(NAME %in% kegg_selRows) %>%
  mutate(LABEL = paste0(KEGG_ko, "\n",ko_name), GROUP = "KEGG PATHWAY") %>%
  mutate(order = 2:(nrow(.)+1)) %>% select(NAME, LABEL, order, GROUP)
kegg_annot$LABEL <- c("KO00040\nPentose\nand\nglucuronate\ninterconversions",
                      "KO00051\nFructose\nand\nmannose\nmetabolism", "KO00052\nGalactose\nmetabolism",
                      "KO00500\nStarch\nand\nsucrose\nmetabolism", "KO00520\nAmino\nsugar and\nnucleotide\nsugar\nmetabolism",
                      "KO04973\nCarbohydrate\ndigestion\nand\nabsorption")   
#
go_annot <- fread("go_annot.txt") %>% 
  mutate(term_short = str_split_i(term,",",i=1)) %>%
  mutate(LABEL = paste0(NAME, "\n", term_short), GROUP = "GO") %>% 
  cbind(order = (1:nrow(.))+7) %>%
  select(NAME, LABEL, order, GROUP)
go_annot$LABEL <- c("GO:0004497\nmono-\noxygenase\nactivity", "GO:0004553\nhydrolase\nactivity",
                    "GO:0004559\nalpha-\nmannosidase\nactivity", "GO:0005975\ncarbohydrate\nmetabolic\nprocess",
                    "GO:0006013\nmannose\nmetabolic\nprocess","GO:0016491\noxidoreductase\nactivity",
                    "GO:0016787\nhydrolase\nactivity") 
g3_annot <- rbind(k_annot, kegg_annot, go_annot)
g3_annot$GROUP <- factor(g3_annot$GROUP, levels = c("KO", "KEGG PATHWAY", "GO"))
#
plot_tbl_b <-  rbind(GSEA_k_subset %>% select(-X, -Substrate) %>% mutate(NAME = `GS.br..follow.link.to.MSigDB`), 
                     GSEA_ko_subset, GSEA_go_subset) %>% 
  left_join(smp_tbl %>% select(species, label, condition, mean_y) %>% unique(), by = "species") %>% 
  left_join(g3_annot, by = "NAME") 
# 
plot_tbl_b$NAME <- factor(plot_tbl_b$NAME, levels = g3_annot$NAME)
plot_tbl_b$LABEL <- factor(plot_tbl_b$LABEL, levels = g3_annot$LABEL)
plot_tbl_b$comparison <- factor(plot_tbl_b$comparison,
                                   levels=c("Fish vs Control", "Mix vs Control","Mix vs Fish","Wild vs Control"))
# k ko go plot ====
bubble_grid_plot_b <- 
  ggplot(plot_tbl_b ,aes(y=label, x=LABEL))+
  facet_grid(comparison~GROUP, scales = "free", space = "free")+
  geom_point(aes(color = -NES, fill = -NES, size = SIZE), shape = 21) +
  theme_bw() +
  theme(
    plot.margin=unit(c(0.2,0.2,0.2,0.2), 'cm'),
    panel.border = element_rect(color = "grey60"),
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 1, size = 5.5, color = "black"),
    axis.text.y = element_text(face = "italic", size = 6, color = c("#4D9221","#4D9221","#08519C","#08519C","#BD0026")),
    strip.background = element_blank(),
    strip.text = element_text(size = 8, face = "bold"),
    text = element_text(color = 'black')
  ) +
  guides(
    col = guide_none(),
    size = guide_none(),#guide_legend("Gene size"),
    fill = guide_none() #guide_colorsteps(barheight = unit(0.3, 'cm'),barwidth = unit(2, 'cm'), title.position = "left"
  ) +
  scale_size_area(max_size = 5) +
  scale_color_viridis_c(
    labels = scales::label_number_auto(),
    na.value = 'grey80'
  ) +
  scale_fill_viridis_c(
    labels = scales::label_number_auto(),
    na.value = 'grey80'
  ) +
  geom_text( 
    aes(label = FDR.q.val), 
    nudge_x = 0.18, 
    nudge_y = 0.05, hjust = 0, vjust = 0, size = 3,
    col = 'brown3'
  ) 
#library(cowplot)
tiff(paste0("Bubble.tiff"), 
     width = 210, height = 297,
     units = 'mm', res = 600, compression = "lzw")
print(
plot_grid(bubble_grid_plot_a,
          bubble_grid_plot_b, labels = LETTERS[1:2], ncol = 1, label_x = 0.01, label_y = 0.99)
)
dev.off()
