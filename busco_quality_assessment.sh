#!/bin/bash
 
#download BUSCO databases from: https://busco-data.ezlab.org/v5/data/lineages/

module load biopython
import Bio
module load hmmer
module load blast

python $BUSCO_DIR/scripts/run_BUSCO.py
busco -i trinity_out_dir/Trinity.fasta -l eudicots_odb10 -o busco_out -m transcriptome
