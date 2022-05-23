#!/bin/bash

#copy peptide files to fasta files
cp Trinity.fasta.transdecoder.pep peptide.fasta

#move peptide fasta files to new orthofinder directory
mkdir orthofinder_dir
mv peptide.fasta orthofinder_dir

#to use STAG and STRIDE instead of msa, remove the "-M msa"
#use -b instead of -f to continue a run
module load mcl
module load python/2.7
orthofinder -f orthofinder_dir -S diamond -M msa
