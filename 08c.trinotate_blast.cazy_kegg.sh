#!/bin/bash
# Use Trinotate blast to annotate the assemblies
set -e

# Define input/output dir
IN_FA_MASTER_DIR="/home/james/crab/06.trinity"
IN_ORF_MASTER_DIR="/home/james/crab/07.transdecoder"
OUT_MASTER_DIR="/home/james/crab/08.trinotate_blast"
CAZYDB="/home/james/databases/cazydb/diamond_makedb/CAZyDB.07292021.diamond.dmnd"
KEGGDB="/home/james/databases/keggdb/diamond_makedb/keggdb.diamond.dmnd"
# all_species="HT1"
all_species="MF1 OP1 PB1 TD1"

#####CAZY
DB_NAME="cazy"
TMP_DB=$CAZYDB
# BLAST Trinity transcripts
TMP_OUT_MASTER_DIR="${OUT_MASTER_DIR}/${DB_NAME}/blast_transcript"
[ -d $TMP_OUT_MASTER_DIR ] || mkdir -p $TMP_OUT_MASTER_DIR
for species in $all_species; do
    echo "[LOG] Diamond blasting against $DB_NAME on trinity transcripts of ${species}..."
    IN_FASTA="${IN_FA_MASTER_DIR}/${species}_trinity.Trinity.fasta"
    diamond blastx --threads 40 \
        --query $IN_FASTA -d $TMP_DB \
        --max-target-seqs 1 --outfmt 6 --evalue 1e-3 \
        --out ${TMP_OUT_MASTER_DIR}/${species}.${DB_NAME}.transcript.blastx.outfmt6 && \
        echo "[LOG] Trinotate blast Trinity transcript completed on ${species}."
done

# BLAST Transdecoder-predicted proteins
TMP_OUT_MASTER_DIR="${OUT_MASTER_DIR}/${DB_NAME}/blast_orf"
[ -d $TMP_OUT_MASTER_DIR ] || mkdir -p $TMP_OUT_MASTER_DIR
for species in $all_species; do
    echo "[LOG] Diamond blasting against $DB_NAME on Transdecoder-predicted proteins of ${species}..."
    IN_PEP="${IN_ORF_MASTER_DIR}/${species}/longest_orfs.pep"
    diamond blastp --threads 40 \
        --query $IN_PEP -d $TMP_DB \
        --max-target-seqs 1 --outfmt 6 --evalue 1e-3 \
        --out ${TMP_OUT_MASTER_DIR}/${species}.${DB_NAME}.transcript.blastp.outfmt6 && \
        echo "[LOG] Trinotate blast Transdecoder-predicted proteins completed on ${species}."
done


#####KEGG
DB_NAME="kegg"
TMP_DB=$KEGGDB
# BLAST Trinity transcripts
TMP_OUT_MASTER_DIR="${OUT_MASTER_DIR}/${DB_NAME}/blast_transcript"
[ -d $TMP_OUT_MASTER_DIR ] || mkdir -p $TMP_OUT_MASTER_DIR
for species in $all_species; do
    echo "[LOG] Diamond blasting against $DB_NAME on trinity transcripts of ${species}..."
    IN_FASTA="${IN_FA_MASTER_DIR}/${species}_trinity.Trinity.fasta"
    diamond blastx --threads 40 \
        --query $IN_FASTA -d $TMP_DB \
        --max-target-seqs 1 --outfmt 6 --evalue 1e-3 \
        --out ${TMP_OUT_MASTER_DIR}/${species}.${DB_NAME}.transcript.blastx.outfmt6 && \
        echo "[LOG] Trinotate blast Trinity transcript completed on ${species}."
done

# BLAST Transdecoder-predicted proteins
TMP_OUT_MASTER_DIR="${OUT_MASTER_DIR}/${DB_NAME}/blast_orf"
[ -d $TMP_OUT_MASTER_DIR ] || mkdir -p $TMP_OUT_MASTER_DIR
for species in $all_species; do
    echo "[LOG] Diamond blasting against $DB_NAME on Transdecoder-predicted proteins of ${species}..."
    IN_PEP="${IN_ORF_MASTER_DIR}/${species}/longest_orfs.pep"
    diamond blastp --threads 40 \
        --query $IN_PEP -d $TMP_DB \
        --max-target-seqs 1 --outfmt 6 --evalue 1e-3 \
        --out ${TMP_OUT_MASTER_DIR}/${species}.${DB_NAME}.transcript.blastp.outfmt6 && \
        echo "[LOG] Trinotate blast Transdecoder-predicted proteins completed on ${species}."
done
