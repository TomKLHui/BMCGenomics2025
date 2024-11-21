#!/usr/bin/bash
# Run cd-hit to cluster isoforms
cur_stage="14.cd-hit"
projectDir="/home/james/crab"
OUTDIR="${projectDir}/${cur_stage}"
TRINITY_DIR="${projectDir}/06.trinity_all"
LOG_MASTER_DIR="${projectDir}/00.code/log/${cur_stage}"
[ -d $LOG_MASTER_DIR ] || mkdir $LOG_MASTER_DIR

all_species="HT1 MF1 OP1 PB1 TD1"
# identities="98 96 94 92 90"
identities="96 94 92 90"
for identity in $identities; do
    OUTDIR_MASTER="${OUTDIR}/c${identity}"
    for species in $all_species; do
        TMP_OUTDIR="${OUTDIR_MASTER}/${species}"
        [ -d $TMP_OUTDIR ] || mkdir -p $TMP_OUTDIR
        LOGFILE="${LOG_MASTER_DIR}/${species}.c${identity}.log"

        cd-hit-est -T 24 \
            -i ${TRINITY_DIR}/${species}_trinity.Trinity.fasta \
            -o ${TMP_OUTDIR}/${species}_cd-hit-cluster_c${identity}.fasta \
            -c 0.${identity} -p 1 -M 16000 -b 3 -d 0
        if [ $? -eq 0 ]; then touch $LOGFILE; fi    # Touch logfile if completed
    done
done