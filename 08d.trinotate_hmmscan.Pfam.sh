#!/bin/bash
# Use Trinotate blast to annotate the assemblies
set -e

# Define input/output dir
IN_ORF_MASTER_DIR="/home/james/crab/07.transdecoder"
OUTDIR="/home/james/crab/08.trinotate/Pfam"
PFAMDB="/home/james/crab/08.trinotate/db/Pfam-A.hmm"
LOG_MASTER_DIR="/home/james/crab/00.code/log/08.trinotate_Pfam"
all_species="HT1 MF1 OP1 PB1 TD1"

[ -d $OUTDIR ] || mkdir -p $OUTDIR
[ -d $LOG_MASTER_DIR ] || mkdir -p $LOG_MASTER_DIR

# HMMSCAN on transdecoder-predicted ORF
for species in $all_species; do
    echo "[LOG] hmmscan against $PFAMDB on trinity ORF of ${species}..."
    IN_ORF="${IN_ORF_MASTER_DIR}/${species}/longest_orfs.pep"
    hmmscan --cpu 20 \
        --domtblout ${OUTDIR}/${species}.TrinotatePFAM.out \
        $PFAMDB $IN_ORF > ${LOG_MASTER_DIR}/${species}.pfam.log && \
        echo "[LOG] Trinotate hmmscan completed on ${species}."
done
