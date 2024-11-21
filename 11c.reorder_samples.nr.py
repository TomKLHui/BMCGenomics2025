#!/usr/bin/env python
# Re-order the sample columns in the matrix

import pandas as pd
from pathlib import Path

workDir = Path('/home/james/crab/11b.functional_annotation.nr')
outDir = workDir/'ordered_matrices'
outDir.mkdir(exist_ok=True)
sampleFileDir = Path('/home/james/crab/00.code/09a.sample_files')
all_species=["HT1", "MF1", "OP1", "PB1", "TD1"]

def reorder_matrix(in_matrix, out_matrix):
    print(f"[LOG] Creating {out_matrix}")
    # Read in_matrix as pd.DataFrame
    in_matrix_df = pd.read_table(in_matrix, index_col=0)

    # Re-order in_matrix_df and save matrix
    out_matrix_df = in_matrix_df.loc[:, sample_order].copy()
    out_matrix_df.to_csv(out_matrix, sep='\t', index=True, index_label="")

for species in all_species:
    # Read sampleFile as a pd.DataFrame
    sampleFile = sampleFileDir/f"09a.sample_files.{species}.txt"
    sampleFile_df = pd.read_table(sampleFile, names=['condition', 'sampleID'], usecols=[0,1])
    sample_order = sampleFile_df.sampleID.tolist()

    # Re-order TMM.EXPR matrix
    in_matrix = workDir/f"{species}.isoform.TMM.EXPR.wAnnot_nr.matrix"
    out_matrix = outDir/f"{species}_ordered.isoform.TMM.EXPR.wAnnot_nr.matrix"
    reorder_matrix(in_matrix, out_matrix)

    # Re-order counts matrix
    in_matrix = workDir/f"{species}.isoform.counts.wAnnot_nr.matrix"
    out_matrix = outDir/f"{species}_ordered.isoform.counts.wAnnot_nr.matrix"
    reorder_matrix(in_matrix, out_matrix)



