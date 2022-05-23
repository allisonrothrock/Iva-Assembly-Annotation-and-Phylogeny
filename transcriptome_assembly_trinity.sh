#!/bin/bash

module load samtools
module load bowtie2

#Trinity v2.1.1

Trinity --seqType fq \
--left left.trimmed.fastq \
--right right.trimmed.fastq \
--SS_lib_type RF \
--max_memory 100G \
--output trinity_out

get_Trinity_gene_to_trans_map.pl Trinity.fasta >  Trinity.fasta.gene_trans_map

#if dies due to memory issues in the jellyfish phase, run at 10G for jellyfish, then return to 100G
