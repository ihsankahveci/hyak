library(stm)

out <- readRDS(file = "out.rds")
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

#finding the optimal number of K
storage <- searchK(docs, vocab, data = meta,
                   K = 3:50,  
                   pprevalence = ~ramadan+sacrifice+budget_share+republic+kurdish+civilians+turkish+location+unemployment,
                   seed = 57, cores=4,
                   verbose=T)

#saving the outputs
pdf("storage_plots.pdf")
plot(storage)
plot(storage$results$K, storage$results$exclus, ylab = 'Exclusivity', xlab = 'Topics')
plot(storage$results$K, storage$results$semcoh, ylab = 'Semantic Coherence', xlab = 'Topics')
dev.off()
saveRDS(storage, "storage.rds")

