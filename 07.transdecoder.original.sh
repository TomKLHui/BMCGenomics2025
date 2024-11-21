#!/bin/bash
# Use TransDecoder to predict ORF from transcriptome assemblies
set -e
prev_stage="06.trinity_original"
cur_stage="07.transdecoder_original"

# Define input/output dir and logfile path
IN_MASTER_DIR="/home/james/crab/${prev_stage}"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
[ -d $OUT_MASTER_DIR ] || mkdir $OUT_MASTER_DIR    # Create $OUT_MASTER_DIR if not existed yet

all_species="HT1 MF1 OP1 PB1 TD1"

for species in $all_species; do
    echo "[LOG] Running TransDecoder on ${species}..."
    IN_FASTA="${IN_MASTER_DIR}/${species}_trinity_out.Trinity.fasta"
    TransDecoder.LongOrfs -t $IN_FASTA && \
        echo "[LOG] TransDecoder completed on ${species}."
done