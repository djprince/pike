#!/bin/bash -l
#SBATCH -o slurm_outs/007_topGenos-%j.out
#SBATCH -t 48:00:00
#SBATCH -p bigmemh
#SBATCH --mem=32G

mkdir 07_topGenos/

angsd -bam 05_pca/all_ss500k.bamlist -out 07_topGenos/all_ss500k_reg_geno4 -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 4 -doPost 2 -r NC_025991.4:700000-900000 -postCutoff 0.8

gunzip 07_topGenos/*gz

