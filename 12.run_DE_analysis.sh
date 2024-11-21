#!/bin/bash
set -e
# Run Trinity DEG analysis
# Using DEseq2 as it has the best true positive rate in similar datatype, and 
# has moderate specificity in similated dataset 
# Source: https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010284

# # Prepare sample files
# cd /home/james/crab/00.code/12a.sample_files
# all_species="HT1 MF1 OP1 PB1 TD1"
# for species in $all_species; do
#     cut -f1,2 ../09a.sample_files/09a.sample_files.${species}.txt > ./12a.sample_files.${species}.txt
# done

# Define the source path
prev_stage="10.abundance_est_to_matrix"
cur_stage="12.run_DE_analysis"
TRINITY_HOME="/home/james/crab/00.code/trinity_source/trinityrnaseq-v2.14.0"
projectDir="/home/james/crab"
SAMPLE_FILE_DIR="${projectDir}/00.code/12a.sample_files"
IN_MASTER_DIR="${projectDir}/${prev_stage}"
OUT_MASTER_DIR="${projectDir}/${cur_stage}"
LOG_MASTER_DIR="${projectDir}/00.code/log/${cur_stage}"
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run the perl script per sample
all_species="HT1 MF1 OP1 PB1 TD1"

for species in $all_species; do
    COUNT_MATRIX="${IN_MASTER_DIR}/${species}/${species}.isoform.counts.matrix"
    SAMPLE_FILE="${SAMPLE_FILE_DIR}/12a.sample_files.${species}.txt"
    OUTDIR="${OUT_MASTER_DIR}/${species}"
    [ -d $OUTDIR ] || mkdir -p $OUTDIR

    ${TRINITY_HOME}/Analysis/DifferentialExpression/run_DE_analysis.pl \
        --matrix $COUNT_MATRIX \
        --method DESeq2 \
        --samples_file $SAMPLE_FILE \
        --output $OUTDIR
done
