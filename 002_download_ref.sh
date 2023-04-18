#!/bin/bash
#SBATCH -t 4-00:00:00
#SBATCH -o slurm_outs/002_ref-%j.out

mkdir 02_genome
cd 02_genome

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/004/634/155/GCF_004634155.1_Eluc_v4/GCF_004634155.1_Eluc_v4_genomic.fna.gz
gunzip *gz

bwa index GCF_004634155.1_Eluc_v4_genomic.fna
