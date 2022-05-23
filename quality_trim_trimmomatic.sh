#!/bin/bash

trimmomatic PE reads_left.fq.gz reads_right.fq.gz \
reads_left.trimmed.fastq  reads_left.unpaired.trimmed.fastq \
reads_right.trimmed.fastq reads_right.unpaired.trimmed.fastq \
ILLUMINACLIP:illumina_adapters.fa:2:30:10:8:TRUE \ #illumina_adapters.fa = custom fasta file containing adapter sequences
LEADING:25 TRAILING:25 SLIDINGWINDOW:10:30 MINLEN:36
