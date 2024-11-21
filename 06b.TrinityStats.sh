#!/bin/bash
# Use Trinity's TrinityStats.pl to get statistics about the Trinity assemblies
set -e

# Define the source path
cur_stage="06b.TrinityStats"
TRINITY_HOME="/home/james/crab/00.code/trinity_source/trinityrnaseq-v2.14.0"
TRANSCRIPT_DIR="/home/james/crab/06.trinity_all"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
LOG_MASTER_DIR="/home/james/crab/00.code/log/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run the perl script per sample
all_species="HT1 MF1 OP1 PB1 TD1"
for species in $all_species; do
    transcript_fa="${TRANSCRIPT_DIR}/${species}_trinity.Trinity.fasta"
    OUT_REPORT="${OUT_MASTER_DIR}/${species}.TrinityStats_report.txt"
    LOGFILE="${LOG_MASTER_DIR}/${species}_completed.log"

    echo "[LOG] Getting statsitics about the Trinity assembly of: ${species}..."    
    ${TRINITY_HOME}/util/TrinityStats.pl \
        $transcript_fa > $OUT_REPORT
    
    if [ $? -eq 0 ]; then touch $LOGFILE; else echo "Error: ${species}"; fi
done
