#!/bin/bash
# prev_stage="03.trim_galore"
# cur_stage="04.fastqc_trimmed"
prev_stage="03.trim_galore_new"
cur_stage="04.fastqc_trimmed_new"

# Define input/output dir and logfile path
IN_MASTER_DIR="/home/james/crab/${prev_stage}"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
LOG_MASTER_DIR="/home/james/crab/00.code/log/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR    # Create $OUT_MASTER_DIR if not existed yet
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR    # Create $LOG_MASTER_DIR if not existed yet
all_species="HT1 MF1 OP1 PB1 TD1"

# Run FASTQC 
for species in $all_species; do
    LOGFILE="${LOG_MASTER_DIR}/${species}.completed.log"
    IN_DIR="${IN_MASTER_DIR}/${species}"
    OUT_DIR="${OUT_MASTER_DIR}/${species}"
    [ -d $OUT_DIR ] || mkdir $OUT_DIR
    fastqc -t 36 -d /home/james/crab/temp --outdir $OUT_DIR ${IN_DIR}/*.fq.gz && touch $LOGFILE
done
