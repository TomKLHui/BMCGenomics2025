#!/bin/bash
prev_stage="03.trim_galore"
cur_stage="06.trinity"

# Define input/output dir and logfile path
IN_MASTER_DIR="/home/james/crab/${prev_stage}"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR    # Create $OUT_MASTER_DIR if not existed yet

all_species="HT1 MF1 OP1 PB1 TD1"

# Run Trinity to perform de novo transcriptome assembly
for species in $all_species; do
    echo "[LOG] Started Trinity on FASTQ: ${species}"
    IN_DIR="${IN_MASTER_DIR}/${species}"
    OUT_DIR="${OUT_MASTER_DIR}/${species}_trinity"
    left_reads=`ls ${IN_DIR}/ | grep _1.trimmed.fq.gz$ | tr '\n' ',' | sed 's/,$//g'`
    right_reads=`ls ${IN_DIR}/ | grep _2.trimmed.fq.gz$ | tr '\n' ',' | sed 's/,$//g'`
    
    cd $IN_DIR
    Trinity --seqType fq --max_memory 100G --CPU 40 \
        --output $OUT_DIR --left $left_reads --right $right_reads
    
    echo -e "[COMPLETE] Trinity completed for: ${species}\n"
done
