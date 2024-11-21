#!/bin/bash
# Run busco to evaluate the Trinity transcriptome assemblies
set -e

# Define the source path
cur_stage="06a.busco"
IN_MASTER_DIR="/home/james/crab/06.trinity_all"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
LOG_MASTER_DIR="/home/james/crab/00.code/log/${cur_stage}"
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run busco to evaluate individual transcriptomes
all_species="HT1 MF1 OP1 PB1 TD1"

for species in $all_species; do
    TRANSCRIPT_FA="${IN_MASTER_DIR}/${species}_trinity.Trinity.fasta"
    OUT_DIR="${OUT_MASTER_DIR}/${species}"
    LOGFILE="${LOG_MASTER_DIR}/${species}_completed.log"

    # Run BUSCO
    echo "[LOG] Run BUSCO to evaluate the transcriptome assembly of: ${species}..."
    [ -d $OUT_DIR ] || mkdir -p $OUT_DIR
    
    cd $OUT_MASTER_DIR
    busco -f --cpu 32 \
        -i $TRANSCRIPT_FA \
        --auto-lineage-euk \
        -o $species \
        -m transcriptome

    if [ $? -eq 0 ]; then touch $LOGFILE; else echo "BUSCO exited with non-zero status"; fi
done

busco -m transcriptome -f \
    -i /home/james/crab/06.trinity_all/HT1_trinity.Trinity.fasta \
    -o /home/james/crab/06a.busco