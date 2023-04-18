.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.6/")
library(optparse)
library(ggplot2)
library(qqman)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (lrt0 output from -doAsso 1)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
)
opt <- parse_args(OptionParser(option_list = option_list))

lrt0 = read.delim(opt$in_file)
outfile = opt$out_file

lrt0 <- lrt0[with(lrt0,order(Chromosome)), ]
lrt0$pval = pchisq(lrt0$LRT,1,lower.tail=F) 

gwas = data.frame(CHR = as.numeric(lrt0$Chromosome),
		  BP = lrt0$Position,
		  P = lrt0$pval,
		  SNP = paste0(lrt0$Chromosome,"_",lrt0$Position))
pdf("test.pdf")
manhattan(gwas)
qq(gwas$P)
dev.off()
