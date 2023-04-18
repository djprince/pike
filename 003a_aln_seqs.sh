#!/bin/bash
#SBATCH -t 4-00:00:00
#SBATCH -o slurm_outs/003_aln-%j.out

mkdir 03_alignments/
mkdir slurm_outs/alignments/
cd 03_alignments/

ls ../01_sequence/*_R[AB].fastq.gz | sed 's:.*01_sequence/::' | sed 's/_R..fastq.gz//' | sort | uniq > ind.list

cat ind.list | while read line
do
	echo "#!/bin/bash
#SBATCH -t 4-00:00:00
#SBATCH -o ../slurm_outs/alignments/${line}-%j.out

	bwa mem ../02_genome/GCF_004634155.1_Eluc_v4_genomic.fna ../01_sequence/${line}_RA.fastq.gz ../01_sequence/${line}_RB.fastq.gz | samtools view -bSf 0x2 | samtools sort > ${line}.sorted.proper.bam
	sorted=\$(samtools view -c ${line}.sorted.proper.bam)
	samtools rmdup ${line}.sorted.proper.bam ${line}.sorted.proper.rmdup.bam
	rmdup=\$(samtools view -c  ${line}.sorted.proper.rmdup.bam)
	rm ${line}.sorted.proper.bam
	samtools index ${line}.sorted.proper.rmdup.bam ${line}.sorted.proper.rmdup.bam.bai
	echo \"\${sorted},\${rmdup}\" > ${line}.stats" > ${line}.sh
	sbatch ${line}.sh
	sleep 10s
	rm ${line}.sh
done
