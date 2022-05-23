#!/bin/bash

cd Trinotate-Trinotate-v3.1.1/admin

module load bowtie2
module load samtools

cp ../../Trinity.fasta .

perl get_Trinity_gene_to_trans_map.pl Trinity.fasta >  Trinity.fasta.gene_trans_map
perl align_and_estimate_abundance.pl --seqType fq --left ../../left.trimmed.fastq  --right ../../right.trimmed.fastq  --transcripts Trinity.fasta --output_prefix file_name --est_method RSEM --aln_method bowtie --prep_reference --output_dir trinity_out_dir

perl Build_Trinotate_Boilerplate_SQLite_db.pl  Trinotate

makeblastdb -in uniprot_sprot.pep -dbtype prot
gunzip Pfam-A.hmm.gz
hmmpress Pfam-A.hmm

TransDecoder.LongOrfs -t Trinity.fasta
TransDecoder.Predict -t Trinity.fasta

blastx -query Trinity.fasta \
  -db uniprot_sprot.pep \
  -num_threads 12 \
  -max_target_seqs 1 \
  -outfmt 6 > blastx_angus.outfmt6

blastp -query Trinity.fasta.transdecoder.pep \
  -db uniprot_sprot.pep \
  -num_threads 12 \
  -max_target_seqs 1 \
  -outfmt 6 > blastp.outfmt6 
  
hmmscan --cpu 12 \
  --domtblout TrinotatePFAM.out \
  Pfam-A.hmm Trinity.fasta.transdecoder.pep > pfam.log

signalp -f short \
  -n signalp.out Trinity.fasta.transdecoder.pep


chmod 644 Trinotate.sqlite

Trinotate Trinotate.sqlite init \
         --gene_trans_map Trinity.fasta.gene_trans_map \
         --transcript_fasta Trinity.fasta \
         --transdecoder_pep Trinity.fasta.transdecoder.pep
         
Trinotate Trinotate.sqlite \
           LOAD_swissprot_blastx blastx.outfmt6

Trinotate Trinotate.sqlite \
           LOAD_swissprot_blastp blastp.outfmt6

Trinotate Trinotate.sqlite LOAD_pfam TrinotatePFAM.out

Trinotate Trinotate.sqlite LOAD_signalp signalp.out

Trinotate Trinotate.sqlite report > Trinotate.xls
