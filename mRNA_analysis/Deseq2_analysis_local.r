library("DESeq2")
library("ggplot2")
library("pheatmap")
cts <- as.matrix(read.csv("KD489_no50_compatiblenames_DEseq2_count-matrix.csv",sep=",",row.names="target_id"))
coldata <- as.matrix(read.csv("KD489_no50_compatiblenames_DEseq2_column-data.csv",sep=",",row.names="sample"))

ddsW <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ batch + KD + timepoint + KD:timepoint)
smallestGroupSize <- 4
keep <- rowSums(counts(ddsW) >= 10) >= smallestGroupSize
ddsW <- ddsW[keep,]
ddsW$KD <- factor(ddsW$KD, levels = c("ND7","PS17","AS17"))
ddsW$timepoint <- factor(ddsW$timepoint, levels = c("veg","20","80","100A"))
ddsW <- DESeq(ddsW)

#transform data for PCA
vsd <- vst(ddsW, blind=FALSE)
pcaData <- plotPCA(vsd, intgroup = c("timepoint", "batch"), returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

#generate PCA plot
ggplot(pcaData, aes(x = PC1, y = PC2, color = timepoint, shape = batch)) +
  geom_point(size =1) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  coord_fixed() +
  ggtitle("PCA with VST data")

#generate plot for individual genes (here Dcl2)
fissDcl2 <- plotCounts(ddsW, 'PTET.51.1.T0210241',intgroup = c("timepoint","KD","batch"), returnData = TRUE)
ggplot(fissDcl2, aes(x = timepoint, y = count, color = KD, group = KD, shape = batch)) + geom_point() + stat_summary(fun.y=mean, geom="line") + ggtitle("DCL2") + theme(plot.title = element_text(hjust = 0.5, vjust = 1)) + ylab(paste0("mRNA\n[normalized counts]")) +  scale_x_discrete(breaks=c("veg","20","80","100A"), labels=c("onset", "early", "late", "very late")) + theme(plot.title = element_text(size = 9), axis.text.x = element_text(size = 7, face = "plain"), axis.text.y = element_text(size = 7, face = "plain"), axis.title.y = element_text(size = 9, face = "plain"))

#caomparison between DevPF KS (As17 and PS17) with ND7 control
resPNv <- results(ddsW, name="KD_PS17_vs_ND7")
resPN20 <- results(ddsW, contrast=list(c("KD_PS17_vs_ND7","KDPS17.timepoint20")))
resPN80 <- results(ddsW, contrast=list(c("KD_PS17_vs_ND7","KDPS17.timepoint80")))
resPN100 <- results(ddsW, contrast=list(c("KD_PS17_vs_ND7","KDPS17.timepoint100A")))
resANv <- results(ddsW, name="KD_AS17_vs_ND7")
resAN20 <- results(ddsW, contrast=list(c("KD_AS17_vs_ND7","KDAS17.timepoint20")))
resAN80 <- results(ddsW, contrast=list(c("KD_AS17_vs_ND7","KDAS17.timepoint80")))
resAN100 <- results(ddsW, contrast=list(c("KD_AS17_vs_ND7","KDAS17.timepoint100A")))

#write the results to a table
write.csv(resPN100, file="DE_results_resPN100.csv")
write.csv(resPN80, file="DE_results_resPN80.csv")
write.csv(resPN20, file="DE_results_resPN20.csv")
write.csv(resPNv, file="DE_results_resPNveg.csv")
write.csv(resAN100, file="DE_results_resAN100.csv")
write.csv(resAN80, file="DE_results_resAN80.csv")
write.csv(resAN20, file="DE_results_resAN20.csv")
write.csv(resANv, file="DE_results_resANveg.csv")

#change the factor levels to make comparison between DevPF1 and DevPF2

library("DESeq2")
library("ggplot2")
library("pheatmap")
cts <- as.matrix(read.csv("KD489_no50_compatiblenames_DEseq2_count-matrix.csv",sep=",",row.names="target_id"))
coldata <- as.matrix(read.csv("KD489_no50_compatiblenames_DEseq2_column-data.csv",sep=",",row.names="sample"))

ddsW <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ batch + KD + timepoint + KD:timepoint)
smallestGroupSize <- 4
keep <- rowSums(counts(ddsW) >= 10) >= smallestGroupSize
ddsW <- ddsW[keep,]
ddsW$KD <- factor(ddsW$KD, levels = c("PS17","AS17","ND7"))
ddsW$timepoint <- factor(ddsW$timepoint, levels = c("veg","20","80","100A"))
ddsW <- DESeq(ddsW)


resAPv <- results(ddsW, name="KD_AS17_vs_PS17")
resAP20 <- results(ddsW, contrast=list(c("KD_AS17_vs_PS17","KDAS17.timepoint20")))
resAP80 <- results(ddsW, contrast=list(c("KD_AS17_vs_PS17","KDAS17.timepoint80")))
resAP100 <- results(ddsW, contrast=list(c("KD_AS17_vs_PS17","KDAS17.timepoint100A")))

write.csv(resAP100, file="DE_results_resAP100.csv")
write.csv(resAP80, file="DE_results_resAP80.csv")
write.csv(resAP20, file="DE_results_resAP20.csv")
write.csv(resAPv, file="DE_results_resAPveg.csv")

