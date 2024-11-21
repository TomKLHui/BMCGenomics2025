#!/bin/bash
set -e
# Functional annotation 

# Define the source path
cur_stage="11.functional_annotation"
TRINITY_HOME="/home/james/crab/00.code/trinity_source/trinityrnaseq-v2.14.0"
TRINOTATE_HOME="/home/james/crab/00.code/trinity_source/Trinotate-Trinotate-v3.2.2"
projectDir="/home/james/crab"
MATRIX_MASTER_DIR="${projectDir}/10.abundance_est_to_matrix"
TRINOTATE_REPORT_DIR="${projectDir}/08.trinotate/sqlite_db"
OUTDIR="${projectDir}/${cur_stage}"
LOGDIR="${projectDir}/00.code/log/${cur_stage}"
[ -d $OUTDIR ] || mkdir -p $OUTDIR
[ -d $LOGDIR ] || mkdir $LOGDIR

# Run the perl script per sample
all_species="HT1 MF1 OP1 PB1 TD1"

for species in $all_species; do
    TRINOTATE_REPORT="${TRINOTATE_REPORT_DIR}/${species}/${species}.trinotate_annotation_report.xls"
    FEATURE_MAP="${OUTDIR}/${species}.annot_feature_map.txt"
    COUNT_MATRIX="${MATRIX_MASTER_DIR}/${species}/${species}.isoform.counts.matrix"
    ANNOT_COUNT_MATRIX="${OUTDIR}/${species}.isoform.counts.wAnnot.matrix"
    TMM_MATRIX="${MATRIX_MASTER_DIR}/${species}/${species}.isoform.TMM.EXPR.matrix"
    ANNOT_TMM_MATRIX="${OUTDIR}/${species}.isoform.TMM.EXPR.wAnnot.matrix"
    COMPLETE_LOG="${LOGDIR}/${species}.completed.log"
    
    # Functional annotation
    ${TRINOTATE_HOME}/util/Trinotate_get_feature_name_encoding_attributes.pl \
        $TRINOTATE_REPORT > $FEATURE_MAP
    # ${TRINITY_HOME}/Analysis/DifferentialExpression/rename_matrix_feature_identifiers.pl \
    #     $COUNT_MATRIX $FEATURE_MAP > $ANNOT_COUNT_MATRIX
    ${TRINITY_HOME}/Analysis/DifferentialExpression/rename_matrix_feature_identifiers.pl \
        $TMM_MATRIX $FEATURE_MAP > $ANNOT_TMM_MATRIX

    if [ $? -eq 0 ]; then touch $COMPLETE_LOG; fi    # Touch complete log
done
