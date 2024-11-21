#!/bin/bash
set -e

# prev_stage="00.raw_data"
# cur_stage="03.trim_galore"
prev_stage="00.raw_data_new"
cur_stage="03.trim_galore_new"

# Define input/output dir and logfile path
IN_MASTER_DIR="/home/james/crab/${prev_stage}"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
LOG_MASTER_DIR="/home/james/crab/00.code/log/${cur_stage}"
TMP_DIR="/home/james/crab/temp"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR    # Create $OUT_MASTER_DIR if not existed yet
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR    # Create $LOG_MASTER_DIR if not existed yet
all_species="HT1 MF1 OP1 PB1 TD1"

# Run TrimGalore to apply adaptor and quality trimming to FASTQ files
for species in $all_species; do
    LOGFILE="${LOG_MASTER_DIR}/${species}.completed.log"
    IN_DIR="${IN_MASTER_DIR}/${species}_RNA"
    OUT_DIR="${OUT_MASTER_DIR}/${species}"
    
    ls ${IN_DIR}/*_1.fq.gz | sed "s/_1\.fq\.gz//g" | parallel --tmpdir $TMP_DIR 'basename {}' | parallel -j1 --tmpdir $TMP_DIR '
    sample={1}
    IN_DIR={2}
    OUT_DIR={3}
    LOGFILE={4}

    trim_galore --cores 40 --gzip --paired --output_dir $OUT_DIR \
        -a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
        -a2 GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG \
        ${IN_DIR}/${sample}_1.fq.gz ${IN_DIR}/${sample}_2.fq.gz && touch $LOGFILE
    
    echo "[LOG] Completed for ${sample}."
    ' :::: - ::: $IN_DIR ::: $OUT_DIR ::: $LOGFILE
done