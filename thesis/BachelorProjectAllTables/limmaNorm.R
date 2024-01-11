library(edgeR)
library(limma)
y <- aggregate(counts ~ type, FUN=sum)
barplot(as.matrix(y[,-1]))

dge <- readDGE("outputs\\collection\\run_01\\merged\\mergedOn_all_biom1.tsv",skip=1, columns = c(1,10),group = sample,group,labels=as.character(samples))


write.table(normalized_counts, file = 'RData\\table_out',sep = "	")