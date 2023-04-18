#!/bin/bash -l
#SBATCH -o slurm_outs/005_pca-%j.out
#SBATCH -t 48:00:00
#SBATCH -p bigmemh
#SBATCH --mem=32G

#mkdir 05_pca 
ls $PWD/03_alignments/*ss500k.bam > 05_pca/all_ss500k.bamlist
#
nInd=$(wc -l 05_pca/all_ss500k.bamlist | awk '{print $1}')
minInd=$[$nInd/2]
#
#angsd -bam 05_pca/all_ss500k.bamlist -out 05_pca/all_ss500k -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 32 -doPost 2 
#
#gunzip 05_pca/all_ss500k*gz
#
#count=$(sed 1d 05_pca/all_ss500k*mafs| wc -l | awk '{print $1}')
#
#/home/djprince/programs/ngsTools/ngsPopGen/ngsCovar -probfile 05_pca/all_ss500k.geno -outfile 05_pca/all_ss500k.covar -nind $nInd -nsites $count -call 1

#angsd -bam 05_pca/all_ss500k.bamlist -out 05_pca/all_ss500k_reg_geno4 -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 4 -doPost 2 -r NC_025991.4:700000-900000

angsd -bam 05_pca/all_ss500k.bamlist -out 05_pca/all_ss500k_reg -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 32 -doPost 2 -r NC_025991.4:700000-900000
#
gunzip 05_pca/all_ss500k_reg*gz
#
count=$(sed 1d 05_pca/all_ss500k_reg*mafs| wc -l | awk '{print $1}')
#
/home/djprince/programs/ngsTools/ngsPopGen/ngsCovar -probfile 05_pca/all_ss500k_reg.geno -outfile 05_pca/all_ss500k_reg.covar -nind $nInd -nsites $count -call 1


ls $PWD/03_alignments/*ss500k.bam | grep -v NPTOTE > 05_pca/noTOTE_ss500k.bamlist
#
nInd=$(wc -l 05_pca/noTOTE_ss500k.bamlist | awk '{print $1}')
minInd=$[$nInd/2]
#
angsd -bam 05_pca/noTOTE_ss500k.bamlist -out 05_pca/noTOTE_ss500k -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 32 -doPost 2 
#
gunzip 05_pca/noTOTE_ss500k*gz
count=$(sed 1d 05_pca/noTOTE_ss500k*mafs| wc -l | awk '{print $1}')
#
/home/djprince/programs/ngsTools/ngsPopGen/ngsCovar -probfile 05_pca/noTOTE_ss500k.geno -outfile 05_pca/noTOTE_ss500k.covar -nind $nInd -nsites $count -call 1
#
