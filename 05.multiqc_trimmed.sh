#!/bin/bash
prev_stage="04.fastqc_trimmed"
cur_stage="05.multiqc_trimmed"

# Define input/output dir and logfile path
IN_MASTER_DIR="/home/james/crab/${prev_stage}"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR    # Create $OUT_MASTER_DIR if not existed yet
all_species="HT1 MF1 OP1 PB1 TD1"

# Run multiqc
for species in $all_species; do
    IN_DIR="${IN_MASTER_DIR}/${species}"
    OUT_DIR="${OUT_MASTER_DIR}/${species}"
    [ -d $OUT_DIR ] || mkdir $OUT_DIR
    cd $OUT_DIR
    multiqc $IN_DIR --filename ./${species}.multiqc
done