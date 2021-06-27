library(stm)

out <- readRDS(file = "hyak/out.rds")
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

#finding the optimal number of K
storage <- manyTopics(docs, vocab, data = meta,
                   K = 3:50,  
                   prevalence = ~ramadan+sacrifice+budget_share+republic+kurdish+civilians+turkish+location+unemployment,  
                   seed = 57, init.type = "Spectral",
                   verbose=T)

#saving the outputs
saveRDS(storage, "hyak/storage.rds")

