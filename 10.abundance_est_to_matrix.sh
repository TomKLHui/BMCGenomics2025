#!/bin/bash
# Use Trinity's align_and_estimate_abundance.pl to quantify transcript abundance
set -e

# Define the source path
prev_stage="09.quantify_transcript"
cur_stage="10.abundance_est_to_matrix"
TRINITY_HOME="/home/james/crab/00.code/trinity_source/trinityrnaseq-v2.14.0"
projectDir="/home/james/crab"
GENE_TRANS_MAP_DIR="${projectDir}/06.trinity_all"
IN_MASTER_DIR="${projectDir}/${prev_stage}"
OUT_MASTER_DIR="${projectDir}/${cur_stage}"
LOG_MASTER_DIR="${projectDir}/00.code/log/${cur_stage}"
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run the perl script per sample
samples="HT1 MF1 OP1 PB1 TD1"

for sample in $samples; do
    INDIR="${IN_MASTER_DIR}/${sample}"
    OUTDIR="${OUT_MASTER_DIR}/${sample}"
    GENE_TRANS_MAP="${GENE_TRANS_MAP_DIR}/${sample}_trinity.Trinity.fasta.gene_trans_map"
    [ -d $OUTDIR ] || mkdir -p $OUTDIR
    cd $OUTDIR
    
    QUANT_FILE="${OUTDIR}/${sample}.quant_files.txt"
    find ${INDIR} -name RSEM.isoforms.results > $QUANT_FILE
    
    ${TRINITY_HOME}/util/abundance_estimates_to_matrix.pl \
        --est_method RSEM \
        --gene_trans_map $GENE_TRANS_MAP \
        --out_prefix ${sample} \
        --name_sample_by_basedir \
        --quant_files $QUANT_FILE
done
