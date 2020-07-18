#!/usr/bin env Rscript
library(DESeq2)
library(org.Hs.eg.db)
args <- commandArgs(TRUE)
n<-length(args)
if (n!=5) stop("\nusage:final_counts.txt normalized_counts.txt normalized_counts_significant.txt results_gene_annotated.txt results_gene_annotated_significant.txt\n")
countdata <- read.table(args[1], header = TRUE, skip = 1, row.names = 1)
colnames(countdata) <- gsub("_Aligned.sortedByCoord.out.bam", "", colnames(countdata), fixed = T)
colnames(countdata) <- gsub("X.home.lanzhzh.workitem.GC_RNAseq.smallRNA.shell....results.4_aligned_sequences.", "", colnames(countdata), fixed = T)
countdata <- countdata[ ,c(-1:-5)]
# head(countdata)
metadata <- read.delim("/home/lanzhzh/workitem/GC_RNAseq/metadata.txt", row.names = 1)
metadata$sampleid <- row.names(metadata)
metadata$sampleid
countdata <- countdata[, metadata$sampleid]
head(countdata)
metadata <- metadata[match(colnames(countdata), metadata$sampleid), ]
metadata
ddsMat <- DESeqDataSetFromMatrix(countData = countdata,
                                 colData = metadata,
                                 design = ~Group)
ddsMat <- DESeq(ddsMat)
results <- results(ddsMat, pAdjustMethod = "fdr", alpha = 0.05)
# summary(results)
mcols(results, use.names = T)
row.names(results)
results$description <- mapIds(x = org.Hs.eg.db, keys = row.names(results), column = "GENENAME", keytype = "SYMBOL", multiVals = "first")
results$symbol <- row.names(results)
results$entrez <- mapIds(x = org.Hs.eg.db, keys = row.names(results), column = "ENTREZID", keytype = "SYMBOL", multiVals = "first")
results$ensembl <- mapIds(x = org.Hs.eg.db, keys = row.names(results), column = "ENSEMBL", keytype = "SYMBOL", multiVals = "first")
results_sig <- subset(results, padj < 0.05)
# head(results_sig)
write.table(x = as.data.frame(counts(ddsMat), normalized = T), file = args[2], sep = '\t', quote = F, col.names = NA)
write.table(x = counts(ddsMat[row.names(results_sig)], normalized = T), file = args[3], sep = '\t', quote = F, col.names = NA)
write.table(x = as.data.frame(results), file = args[4], sep = '\t', quote = F, col.names = NA)
write.table(x = as.data.frame(results_sig), file = args[5], sep = '\t', quote = F, col.names = NA)
