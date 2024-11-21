#!/bin/bash
# Use TransRate to get statistics about the Trinity assemblies
set -e

# Define the source path
cur_stage="06c.transrate"
projectDir="/home/james/crab"
FQ_MASTER_DIR="${projectDir}/03.trim_galore_all"
TRANSCRIPT_DIR="${projectDir}/06.trinity_all"
OUT_MASTER_DIR="${projectDir}/${cur_stage}"
LOG_MASTER_DIR="${projectDir}/00.code/log/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run the perl script per sample
all_species="HT1 MF1 OP1 PB1 TD1"
for species in $all_species; do
    transcript_fa="${TRANSCRIPT_DIR}/${species}_trinity.Trinity.fasta"
    FQ_DIR="${FQ_MASTER_DIR}/${species}"
    # LEFT_READS=`ls $FQ_DIR/*_1_val_1.fq.gz | sort | tr '\n' ','`
    # RIGHT_READS=`ls $FQ_DIR/*_2_val_2.fq.gz | sort | tr '\n' ','`
    OUTDIR="${OUT_MASTER_DIR}/${species}"
    LOGFILE="${LOG_MASTER_DIR}/${species}_completed.log"

    echo "[LOG] Getting statsitics about the Trinity assembly of: ${species}..."
    transrate --threads 32 \
        --assembly $transcript_fa \
        --output $OUTDIR
    
    if [ $? -eq 0 ]; then touch $LOGFILE; else echo "Error: ${species}"; fi
done
