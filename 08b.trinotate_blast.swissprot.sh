#!/bin/bash
# Use Trinotate blast to annotate the assemblies
set -e

# Define input/output dir
IN_FA_MASTER_DIR="/home/james/crab/06.trinity_all"
IN_ORF_MASTER_DIR="/home/james/crab/07.transdecoder"
DB_NAME="uniprot"
OUT_MASTER_DIR="/home/james/crab/08.trinotate/${DB_NAME}"
DB="/home/james/crab/08.trinotate/db/uniprot_sprot.diamond.dmnd"
all_species="HT1 MF1 OP1 PB1 TD1"

# BLAST Trinity transcripts
TMP_OUT_MASTER_DIR="${OUT_MASTER_DIR}/blast_transcript"
[ -d $TMP_OUT_MASTER_DIR ] || mkdir -p $TMP_OUT_MASTER_DIR
for species in $all_species; do
    echo "[LOG] Diamond blasting against $DB_NAME on trinity transcripts of ${species}..."
    IN_FASTA="${IN_FA_MASTER_DIR}/${species}_trinity.Trinity.fasta"
    diamond blastx --threads 20 \
        --query $IN_FASTA -d $DB \
        --max-target-seqs 1 --outfmt 6 --evalue 1e-3 \
        --out ${TMP_OUT_MASTER_DIR}/${species}.${DB_NAME}.transcript.blastx.outfmt6 && \
        echo "[LOG] Trinotate blast Trinity transcript completed on ${species}."
done

# BLAST Transdecoder-predicted proteins
TMP_OUT_MASTER_DIR="${OUT_MASTER_DIR}/blast_orf"
[ -d $TMP_OUT_MASTER_DIR ] || mkdir -p $TMP_OUT_MASTER_DIR
for species in $all_species; do
    echo "[LOG] Diamond blasting against $DB_NAME on Transdecoder-predicted proteins of ${species}..."
    IN_PEP="${IN_ORF_MASTER_DIR}/${species}/longest_orfs.pep"
    diamond blastp --threads 20 \
        --query $IN_PEP -d $DB \
        --max-target-seqs 1 --outfmt 6 --evalue 1e-3 \
        --out ${TMP_OUT_MASTER_DIR}/${species}.${DB_NAME}.transcript.blastp.outfmt6 && \
        echo "[LOG] Trinotate blast Transdecoder-predicted proteins completed on ${species}."
done
