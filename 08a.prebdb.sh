# Uniprot
cd /home/james/crab/08.trinotate/db
wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
diamond makedb --in uniprot_sprot.fasta.gz --db uniprot_sprot.diamond

# CAZY
cd /home/james/databases/cazydb/diamond_makedb
diamond makedb --in ../CAZyDB.07292021.fa --db CAZyDB.07292021.diamond

# KEGG
cd /home/james/databases/keggdb/diamond_makedb
diamond makedb --in ../keggdb.fasta --db keggdb.diamond
