#!/bin/bash
# Use Trinotate singalP to annotate the assemblies
set -e

# Define input/output dir
IN_ORF_MASTER_DIR="/home/james/crab/07.transdecoder"
OUTDIR="/home/james/crab/08.trinotate/signalP"
LOG_MASTER_DIR="/home/james/crab/00.code/log/08.trinotate_signalP"
all_species="HT1 MF1 OP1 PB1 TD1"
SIGNALP="/home/james/crab/00.code/signalp_source/signalp-4.1/signalp"

[ -d $OUTDIR ] || mkdir -p $OUTDIR
[ -d $LOG_MASTER_DIR ] || mkdir -p $LOG_MASTER_DIR

# SignalP on transdecoder-predicted ORF
for species in $all_species; do
    echo "[LOG] Running signalP on trinity ORF of ${species}..."
    IN_ORF="${IN_ORF_MASTER_DIR}/${species}/longest_orfs.pep"
    $SIGNALP -f short -n ${OUTDIR}/${species}.signalp.out $IN_ORF \
        && echo "[LOG] Trinotate signalP completed on ${species}."
done
