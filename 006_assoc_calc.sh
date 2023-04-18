#!/bin/bash -l
#SBATCH -o slurm_outs/006_assoc-%j.out
#SBATCH -p bigmemh
#SBATCH --mem=32G
#SBATCH -t 4-00:00:00 

mkdir 06_assoc
ls $PWD/03_alignments/*ss500k*bam | sed 's/_ss500k//g' > 06_assoc/all_ss500k.bamlist

sed -r 's/^.*_M.sorted.*/1/g' 06_assoc/all_ss500k.bamlist | sed -r 's/^.*_F.sorted.*/0/g' > 06_assoc/all_ss500k.ybin

nInd=$(wc -l 06_assoc/all_ss500k.bamlist | awk '{print $1}')
minInd=$[$nInd/2]

angsd -bam 06_assoc/all_ss500k.bamlist -out 06_assoc/all_ss500k -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doAsso 1 -yBin 06_assoc/all_ss500k.ybin -model 2

gunzip 06_assoc/all_ss500k*gz

Rscript scripts/plot_assoc.R -i 06_assoc/all_ss500k.lrt0 -o 06_assoc/all_ss500k_assoc.pdf
