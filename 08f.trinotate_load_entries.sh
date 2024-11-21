# Load results into a Trinotate sqlite database
TRINITY_DIR="/home/james/crab/06.trinity_all"
TRINOTATE_HOME="/home/james/crab/00.code/trinity_source/Trinotate-Trinotate-v3.2.2"
TRINOTATE="/home/james/crab/00.code/trinity_source/Trinotate-Trinotate-v3.2.2/Trinotate"
TRINOTATE_OUTDIR="/home/james/crab/08.trinotate"
OUT_MASTER_DIR="/home/james/crab/08.trinotate/sqlite_db"
all_species="HT1 MF1 OP1 PB1 TD1"
species=$1    # Change the species ID here and resume all analysis
OUTDIR="${OUT_MASTER_DIR}/${species}"

[ -d $OUTDIR ] || mkdir -p $OUTDIR
cd $OUTDIR

#####Initiate the Trinotate sqlite database
TRINITY_TRANSCRIPT="${TRINITY_DIR}/${species}_trinity.Trinity.fasta"
GENE_TRANS_MAP="${TRINITY_DIR}/${species}_trinity.Trinity.fasta.gene_trans_map"
TRANSDECODER_ORF="/home/james/crab/07.transdecoder/${species}/longest_orfs.pep"

# Build a Trinotate SQLite database
$TRINOTATE_HOME/admin/Build_Trinotate_Boilerplate_SQLite_db.pl ${species}.Trinotate

$TRINOTATE ${species}.Trinotate.sqlite init \
    --gene_trans_map $GENE_TRANS_MAP \
    --transcript_fasta $TRINITY_TRANSCRIPT \
    --transdecoder_pep $TRANSDECODER_ORF


#####Load blast results

# Uniprot
DB_NAME="uniprot"
BLASTX_OUT="${TRINOTATE_OUTDIR}/${DB_NAME}/blast_transcript/${species}.${DB_NAME}.transcript.blastx.outfmt6"
BLASTP_OUT="${TRINOTATE_OUTDIR}/${DB_NAME}/blast_orf/${species}.${DB_NAME}.transcript.blastp.outfmt6"

$TRINOTATE ${species}.Trinotate.sqlite LOAD_swissprot_blastx $BLASTX_OUT
$TRINOTATE ${species}.Trinotate.sqlite LOAD_swissprot_blastp $BLASTP_OUT

# Cazy
DB_NAME="cazy"
DBTYPE="CAZyDB.07292021.diamond"
BLASTX_OUT="${TRINOTATE_OUTDIR}/${DB_NAME}/blast_transcript/${species}.${DB_NAME}.transcript.blastx.outfmt6"
BLASTP_OUT="${TRINOTATE_OUTDIR}/${DB_NAME}/blast_orf/${species}.${DB_NAME}.transcript.blastp.outfmt6"

$TRINOTATE ${species}.Trinotate.sqlite LOAD_custom_blast \
    --outfmt6 $BLASTX_OUT --prog blastx \
    --dbtype $DBTYPE
$TRINOTATE ${species}.Trinotate.sqlite LOAD_custom_blast \
    --outfmt6 $BLASTP_OUT --prog blastp \
    --dbtype $DBTYPE

# Kegg
DB_NAME="kegg"
DBTYPE="keggdb.diamond"
BLASTX_OUT="${TRINOTATE_OUTDIR}/${DB_NAME}/blast_transcript/${species}.${DB_NAME}.transcript.blastx.outfmt6"
BLASTP_OUT="${TRINOTATE_OUTDIR}/${DB_NAME}/blast_orf/${species}.${DB_NAME}.transcript.blastp.outfmt6"

$TRINOTATE ${species}.Trinotate.sqlite LOAD_custom_blast \
    --outfmt6 $BLASTX_OUT --prog blastx \
    --dbtype $DBTYPE
$TRINOTATE ${species}.Trinotate.sqlite LOAD_custom_blast \
    --outfmt6 $BLASTP_OUT --prog blastp \
    --dbtype $DBTYPE

# Pfam domain entries
PFAM_OUT="${TRINOTATE_OUTDIR}/Pfam/${species}.TrinotatePFAM.out"
$TRINOTATE ${species}.Trinotate.sqlite LOAD_pfam $PFAM_OUT

# SignalP entries
SIGNALP_OUT="${TRINOTATE_OUTDIR}/signalP/${species}.signalp.out"
$TRINOTATE ${species}.Trinotate.sqlite LOAD_signalp $SIGNALP_OUT

#####Output annotatione report
$TRINOTATE ${species}.Trinotate.sqlite report \
    --incl_pep --incl_trans > ${species}.trinotate_annotation_report.xls

