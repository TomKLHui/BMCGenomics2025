#!/usr/bin/env python
# Re-order the sample columns in the matrix

import pandas as pd
from pathlib import Path

workDir = Path('/home/james/crab/11.functional_annotation')
sampleFileDir = Path('/home/james/crab/00.code/09a.sample_files')
all_species=["HT1", "MF1", "OP1", "PB1", "TD1"]

species = "PB1"
in_matrix = workDir/f"{species}.isoform.TMM.EXPR.wAnnot.matrix"
out_matrix = workDir/f"{species}_ordered.isoform.TMM.EXPR.wAnnot.matrix"
sampleFile = sampleFileDir/f"09a.sample_files.{species}.txt"

# Read sampleFile as a pd.DataFrame
sampleFile_df = pd.read_table(sampleFile, names=['condition', 'sampleID'], usecols=[0,1])
sample_order = sampleFile_df.sampleID.tolist()

# Read in_matrix as pd.DataFrame
in_matrix_df = pd.read_table(in_matrix, index_col=0)

# Re-order in_matrix_df and save matrix
out_matrix_df = in_matrix_df.loc[:, sample_order].copy()
out_matrix_df.to_csv(out_matrix, sep='\t', index=True, index_label="")

