#!/bin/bash
#SBATCH -t 4-00:00:00
#SBATCH -o slurm_outs/004_rename-%j.out

cat NP01.metadata | while read line
do
	var=$(echo $line | awk -F"\t" '{print $1,$2,$3,$4,$5}')
	set -- $var
	c1=$1
	c2=$2
	c3=$3
	c4=$4
	c5=$5

#	rename "s/NP01_GG${c5}TGCAGG/${c1}_${c2}_${c3}/" 03_alignments/NP01_GG${c5}TGCAGG*
	count=$(samtools view -c 03_alignments/${c1}_${c2}_${c3}.sorted.proper.rmdup.bam)

        if [ 500000 -le $count ]
        then
                frac=$(bc -l <<< 500000/$count)
	        samtools view -bs $frac 03_alignments/${c1}_${c2}_${c3}.sorted.proper.rmdup.bam > 03_alignments/${c1}_${c2}_${c3}.sorted.proper.rmdup.ss500k.bam
		samtools index 03_alignments/${c1}_${c2}_${c3}.sorted.proper.rmdup.ss500k.bam 03_alignments/${c1}_${c2}_${c3}.sorted.proper.rmdup.ss500k.bam.bai
	fi
done
