.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.6/")
library(optparse)
library(ggplot2)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (lrt0 output from -doAsso 1)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
)
opt <- parse_args(OptionParser(option_list = option_list))

lrt0 = read.delim(opt$in_file)
outfile = opt$out_file

lrt0 <- lrt0[with(lrt0,order(Chromosome)), ]

lrt0$pval = pchisq(lrt0$LRT,1,lower.tail=F) 
lrt0$val = -log(lrt0$pval, 10)
bonf_val = -log(0.05/length(lrt0$pval),10)

nCHR = length(unique(lrt0$Chromosome))
lrt0$pos2 <- NA
s <- 0
nbp <- c()
for (i in unique(lrt0$Chromosome)){
	  nbp[i] <- max(lrt0[lrt0$Chromosome == i,]$Position)
  lrt0[lrt0$Chromosome == i,"pos2"] <- lrt0[lrt0$Chromosome == i,"Position"] + s
    s <- s + nbp[i] + 10000000
}

pdf(outfile)
  ggplot() + theme_bw(base_size = 6) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), legend.position = "none") +
    geom_point(data= lrt0, aes(x=lrt0$pos2, y=lrt0$val, color = lrt0$Chromosome), size = 1) +
    scale_y_continuous(breaks=c(0,5,10,15,20), labels=c("0","5","10","15","20")) +
    ylab(label = expression('-log'[10]*'(p-value)')) + theme(axis.title.y=element_text(), axis.title.x=element_text(angle=0, vjust=-.5, hjust=0.5)) +
    geom_hline(yintercept=bonf_val, color='red', linetype ='dashed') + 
    scale_color_manual(values = c("grey",rep(c("skyblue","grey"),(nCHR/2))))
dev.off()

