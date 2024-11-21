#!/bin/bash
prev_stage="00.raw_data"
cur_stage="01.fastqc_raw"

# Define input/output dir and logfile path
IN_DIR="/home/james/crab/${prev_stage}"
OUT_DIR="/home/james/crab/${cur_stage}"
LOGFILE="/home/james/crab/00.code/log/${cur_stage}.log"
[ -d $OUT_DIR ] || mkdir $OUT_DIR    # Create $OUT_DIR if not existed yet
all_species="HT1 MF1 OP1 PB1 TD1"

# Run FASTQC 
for species in $all_species; do
    TMP_OUT_DIR="${OUT_DIR}/${species}"
    [ -d $TMP_OUT_DIR ] || mkdir $TMP_OUT_DIR
    fastqc -t 36 ${IN_DIR}/${species}_RNA/*.fq.gz --outdir $TMP_OUT_DIR
done