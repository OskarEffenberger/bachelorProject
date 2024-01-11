library(metagenomeSeq)
data1 <- read.table('RData\\table', header = FALSE,  sep = '	',  stringsAsFactors = FALSE)

metaSeqObject = newMRexperiment(data1) 
metaSeqObject_CSS  = cumNorm( metaSeqObject , p=0.8 )
OTU_read_count_CSS = MRcounts(metaSeqObject_CSS, norm=TRUE, log=FALSE,sl=1000)
write.table(OTU_read_count_CSS, file = 'RData\\table_out',sep = "	")
