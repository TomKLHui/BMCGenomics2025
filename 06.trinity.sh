#!/bin/bash
prev_stage="03.trim_galore"
cur_stage="06.trinity"

# Define input/output dir and logfile path
IN_MASTER_DIR="/home/james/crab/${prev_stage}"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR    # Create $OUT_MASTER_DIR if not existed yet
# all_species="HT1 MF1 OP1 PB1 TD1"
all_species="HT1 MF1"

# Run Trinity to perform de novo transcriptome assembly
# Running per sample
for species in $all_species; do
    IN_DIR="${IN_MASTER_DIR}/${species}"
    cd $IN_DIR
    
    ls ${IN_DIR} | grep _1.trimmed.fq.gz$ | cut -d'_' -f1,2,3 | parallel -j1 '
    id={1}
    species={2}
    OUT_MASTER_DIR={3}

    OUT_DIR="${OUT_MASTER_DIR}/${species}_persample/${id}.trinity"
    left_reads="${id}_1_trimmed.fq.gz"
    right_reads="${id}_2_trimmed.fq.gz"

    Trinity --seqType fq --max_memory 60G --CPU 24 \
        --output $OUT_DIR --left $left_reads --right $right_reads
    ' :::: - ::: $species ::: $OUT_MASTER_DIR
    echo -e "[COMPLETE] Trinity completed for: ${species}\n"
done