#!/bin/bash
prev_stage="01.fastqc_raw"
cur_stage="02.multiqc_raw"

# Define input/output dir and logfile path
IN_DIR="/home/james/crab/${prev_stage}"
OUT_DIR="/home/james/crab/${cur_stage}"
LOGFILE="/home/james/crab/00.code/log/${cur_stage}.log"
[ -d $OUT_DIR ] || mkdir $OUT_DIR    # Create $OUT_DIR if not existed yet
all_species="HT1 MF1 OP1 PB1 TD1"

# Run multiqc
for species in $all_species; do
    TMP_IN_DIR="${IN_DIR}/${species}"
    TMP_OUT_DIR="${OUT_DIR}/${species}"
    [ -d $TMP_OUT_DIR ] || mkdir $TMP_OUT_DIR
    cd $TMP_OUT_DIR
    multiqc $TMP_IN_DIR --filename ./multiqc.log
done