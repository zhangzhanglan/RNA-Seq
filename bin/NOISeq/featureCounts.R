#!/usr/bin env Rscript
library(NOISeq)
library(org.Hs.eg.db)
args <- commandArgs(TRUE)
n<-length(args)
if (n!=6) stop("\nusage:final_counts.txt normalized_counts.txt normalized_counts_significant.txt results_gene_annotated.txt results_gene_annotated_significant.txt sample\n")
args[6]
countdata <- read.table(args[1], header = TRUE, skip = 1, row.names = 1)
colnames(countdata) <- gsub("_Aligned.sortedByCoord.out.bam", "", colnames(countdata), fixed = T)
colnames(countdata) <- gsub("X.home.lanzhzh.workitem.GC_RNAseq.smallRNA.shell....results.4_aligned_sequences.", "", colnames(countdata), fixed = T)
# mychroms <- countdata[, c(1:5)]
countdata <- countdata[ ,c(-1:-5)]
metadata_all <- read.delim("/home/lanzhzh/workitem/GC_RNAseq/metadata.txt", row.names = 1)
# metadata_all <- read.delim("/home/lanzhzh/workitem/GC_RNAseq/metadata_APS.txt", row.names = 1)
select_sample <- c("Control", args[6])
metadata <- metadata_all[select_sample, ]
metadata
metadata$sampleid <- row.names(metadata)
metadata$sampleid
countdata <- countdata[, metadata$sampleid]
head(countdata)
metadata <- metadata[match(colnames(countdata), metadata$sampleid), ]	# check
# row.names(countdata)
# countdata$ensembl <- mapIds(x = org.Hs.eg.db, keys = row.names(countdata), column = "ENSEMBL", keytype = "SYMBOL", multiVals = "first")
# countdata$ensembl
mfactors <- matrix(metadata$sampleid, nrow = 2, ncol = 1, byrow = TRUE, dimnames = list(c("control", "treatment"), c("sample")))
mfactors
mydata <- readData(data=countdata, factors=mfactors)
getNOIseqRes <- noiseq(mydata, k = 0.1, norm = "uqua", replicates = "no", factor="sample", pnr = 0.2, nss = 10)
write.table(getNOIseqRes@results[[1]], file="afterNoiseq.txt", sep="\t", row.names=T, col.names=T, quote=F)
mynoiseq.deg = degenes(getNOIseqRes, q = 0.9, M = NULL)
mynoiseq.deg1 = degenes(getNOIseqRes, q = 0.9, M = "up")
mynoiseq.deg2 = degenes(getNOIseqRes, q = 0.9, M = "down")
mynoiseq.deg
write.table(mynoiseq.deg, file="afterNoiseq_sig.txt", sep="\t", row.names=T, col.names=T, quote=F)
DE.plot(getNOIseqRes, q = 0.9, graphic = "expr", log.scale = TRUE)
DE.plot(getNOIseqRes, q = 0.8, graphic = "MD")
