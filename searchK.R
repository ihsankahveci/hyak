library(stm)
library(readr)


sermons = read_csv("../sermons_final.csv")
#sermons = read_csv("sermons_final.csv")

#preprocessing the text
processed <- textProcessor(sermons$translated, metadata=sermons, 
                           language = "en", stem = T) #citation 

out <- prepDocuments(processed$documents, processed$vocab, processed$meta,
                     upper.thresh = 100, lower.thresh = 20)
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

#finding the optimal number of K
storage <- searchK(docs, vocab, data = meta,
                   K = 3:50,  
                   prevalence = ~turkish + kurdish + price + location + ramadan + sacrifice,  
                   seed = 57, cores=8,
                   verbose=T)

#saving the outputs
pdf("storage_plots.pdf")
plot(storage)
plot(storage$results$K, storage$results$exclus, ylab = 'Exclusivity', xlab = 'Topics')
plot(storage$results$K, storage$results$semcoh, ylab = 'Semantic Coherence', xlab = 'Topics')
dev.off()
save(storage, file = "storage.RData")

