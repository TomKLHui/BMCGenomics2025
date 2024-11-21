#!/bin/bash
set -e
# GO analysis

# Define the source path
cur_stage="13.GO_analysis"
TRINITY_HOME="/home/james/crab/00.code/trinity_source/trinityrnaseq-v2.14.0"
TRINOTATE_HOME="/home/james/crab/00.code/trinity_source/Trinotate-Trinotate-v3.2.2"
projectDir="/home/james/crab"
SAMPLE_FILE_DIR="${projectDir}/00.code/12a.sample_files"
TRINOTATE_REPORT_DIR="${projectDir}/08.trinotate/sqlite_db"
TRINITY_DIR="${projectDir}/06.trinity_all"
MATRIX_DIR="${projectDir}/10.abundance_est_to_matrix"
DE_RESULT_MASTER_DIR="${projectDir}/12.run_DE_analysis"
OUT_MASTER_DIR="${projectDir}/${cur_stage}"
LOG_MASTER_DIR="${projectDir}/00.code/log/${cur_stage}"
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run the perl script per species
all_species="HT1 MF1 OP1 PB1 TD1"

for species in $all_species; do
    TRINOTATE_REPORT="${TRINOTATE_REPORT_DIR}/${species}/${species}.trinotate_annotation_report.xls"
    TRINITY_FA="${TRINITY_DIR}/${species}_trinity.Trinity.fasta"
    GENE_TRANS_MAP="${TRINITY_DIR}/${species}_trinity.Trinity.fasta.gene_trans_map"
    TMM_MATRIX="${MATRIX_DIR}/${species}/${species}.isoform.TMM.EXPR.matrix"
    OUTDIR="${OUT_MASTER_DIR}/${species}"
    FEATURE_MAP="${OUTDIR}/${species}.annot_feature_map.txt"
    SAMPLE_FILE="${SAMPLE_FILE_DIR}/12a.sample_files.${species}.txt"
    DE_RESULT_DIR="${DE_RESULT_MASTER_DIR}/${species}"
    [ -d $OUTDIR ] || mkdir -p $OUTDIR
    cd $DE_RESULT_DIR

    # Define output files for each stage
    GO_ANNOTATIONS="${OUTDIR}/${species}.go_annotations.txt"
    FACTOR_LABELING="${OUTDIR}/${species}.factor_labeling.txt"
    FA_GENE_LENGTH="${OUTDIR}/${species}_Trinity.fasta.seq_lens"
    TRINITY_GENE_LENGTH="${OUTDIR}/${species}_Trinity.gene_lengths.txt"
    COMPLETE_LOG="${LOG_MASTER_DIR}/${species}.completed.log"
    
    # Extract GO sassignments per gene
    echo "[LOG] ${species} - Extracting GO assignments per gene"    # Logging
    ${TRINOTATE_HOME}/util/extract_GO_assignments_from_Trinotate_xls.pl \
        --Trinotate_xls $TRINOTATE_REPORT \
        -G --include_ancestral_terms \
        > $GO_ANNOTATIONS
    if [ $? -ne 0 ]; then 
        echo "[LOG] ${species} - ERROR when extracting GO assignments per gene"
        exit
    else
        echo "[DONE] ${species} - Extracting GO assignments per gene"    # Logging
    fi

    # Get Gene length file
    echo "[LOG] ${species} - Prepare gene length file"
    ${TRINITY_HOME}/util/misc/fasta_seq_length.pl $TRINITY_FA > $FA_GENE_LENGTH
    ${TRINITY_HOME}/util/misc/TPM_weighted_gene_length.py \
        --gene_trans_map $GENE_TRANS_MAP \
        --trans_length $FA_GENE_LENGTH \
        --TPM_matrix $TMM_MATRIX > $TRINITY_GENE_LENGTH
    if [ $? -ne 0 ]; then 
        echo "[LOG] ${species} - ERROR when preparing gene length file"
        exit
    else
        echo "[DONE] ${species} - Prepare gene length file"    # Logging
    fi
    
    # Run GO analysis
    echo "[LOG] ${species} - Run GOseq"
    ${TRINITY_HOME}/Analysis/DifferentialExpression/analyze_diff_expr.pl \
        --matrix $TMM_MATRIX \
        --samples $SAMPLE_FILE \
        --order_columns_by_samples_file \
        --examine_GO_enrichment \
        --GO_annots $GO_ANNOTATIONS \
        --gene_lengths $TRINITY_GENE_LENGTH \
        --output ${OUTDIR}/${species}.diffExpr
    if [ $? -ne 0 ]; then 
        echo "[LOG] ${species} - ERROR when running GOseq"
        exit
    else
        touch $COMPLETE_LOG
        echo "[DONE] ${species} - Run GOseq"    # Logging
    fi
done
