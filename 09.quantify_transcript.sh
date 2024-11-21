#!/bin/bash
# Use Trinity's align_and_estimate_abundance.pl to quantify transcript abundance
set -e

# Define the source path
cur_stage="09.quantify_transcript"
TRINITY_HOME="/home/james/crab/00.code/trinity_source/trinityrnaseq-v2.14.0"
SAMPLE_FILE_DIR="/home/james/crab/00.code/09a.sample_files"
TRANSCRIPT_DIR="/home/james/crab/06.trinity_all"
FQ_MASTER_DIR="/home/james/crab/03.trim_galore_all"
OUT_MASTER_DIR="/home/james/crab/${cur_stage}"
LOG_MASTER_DIR="/home/james/crab/00.code/log/${cur_stage}"
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

# Run the perl script per sample
# all_species="HT1 MF1 OP1 PB1 TD1"
all_species="TD1"
for species in $all_species; do
    transcript_fa="${TRANSCRIPT_DIR}/${species}_trinity.Trinity.fasta"
    GENE_TRANS_MAP="${TRANSCRIPT_DIR}/${species}_trinity.Trinity.fasta.gene_trans_map"
    sample_file="${SAMPLE_FILE_DIR}/09a.sample_files.tmp_${species}.txt"
    FQ_DIR="${FQ_MASTER_DIR}/${species}"
    OUT_DIR="${OUT_MASTER_DIR}/${species}"
    LOGFILE="${LOG_MASTER_DIR}/${species}_completed.log"

    echo "[LOG] Estimate samples' transcript abundance: ${species}..."
    [ -d $OUT_DIR ] || mkdir -p $OUT_DIR
    
    # Estimate abundance per FASTQ
    cd $OUT_DIR
    ${TRINITY_HOME}/util/align_and_estimate_abundance.pl \
        --transcripts $transcript_fa \
        --seqType fq \
        --est_method RSEM \
        --output_dir $OUT_DIR \
        --aln_method bowtie2 \
        --thread_count 20 \
        --gene_trans_map $GENE_TRANS_MAP \
        --samples_file $sample_file
        # --prep_reference
done
