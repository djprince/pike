#!/bin/bash -l
#SBATCH -o 05_pca/06_pca_plot-%j.out
ls 05_pca/*covar | sed 's:05_pca/::g' | sed 's:.covar::g' > list

wc=$(wc -l list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p list" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1

	#make annot file from bamlist (clst format)
	echo "FID_IID_CLUSTER_IDVAR" | awk -F_ '{print $1"\t"$2"\t"$3"\t"$4}'> 05_pca/${c1}.clst
	cat 05_pca/${c1}.bamlist | sed 's:.*alignments/::g' | sed 's:.sorted.*::' | cut -d"_" -f1 > tmp1; cat 05_pca/${c1}.bamlist | sed 's:.*alignments/::g' | sed 's:.sorted.*::' | cut -d"_" -f2 > tmp2; cat 05_pca/${c1}.bamlist | sed 's:.*alignments/::g' | sed 's:.sorted.*::' | cut -d"_" -f3 > tmp3; cat 05_pca/${c1}.bamlist | sed 's:.*alignments/::g' | sed 's:.sorted.*::' | cut -d"_" -f4 > tmp4; paste tmp1 tmp2 tmp3 tmp4 | awk -F"\t" '{print $1"\t"$2"\t"$3"\t1"}' >> 05_pca/${c1}.clst ; rm tmp1 tmp2 tmp3 tmp4

	#plot pdfs
        Rscript --vanilla --slave scripts/plot_pca.R -i 05_pca/${c1}.covar -c 1-2 -a 05_pca/${c1}.clst -o 05_pca/${c1}_12_pca.pdf
        Rscript --vanilla --slave scripts/plot_pca.R -i 05_pca/${c1}.covar -c 3-4 -a 05_pca/${c1}.clst -o 05_pca/${c1}_34_pca.pdf
 
x=$(( $x + 1 ))
done
rm list

