library(dplyr)
library(stm)

out <- readRDS(file = "out.rds")
docs <- out$documents
vocab <- out$vocab
meta  <- mutate(out$meta, turkish = ifelse(as.numeric(turkish) > 2, 1, 0))

stm_perm = stm(docs, vocab, data = meta,
               K = 22,  
               prevalence = ~holy_days+budget_share+turkish+location+unemployment,
               seed = 57,
               verbose = F)

perm_test = permutationTest(~holy_days+budget_share+turkish+location+unemployment, 
                            stmobj = stm_perm,
                            treatment = "turkish", 
                            seed = 57,
                            vocab = vocab, data=meta, documents = docs)

#saving the outputs
pdf("perm_plot.pdf")
plot(perm_test, topic = 10)
dev.off()
saveRDS(perm_test, "perm_test.rds")
