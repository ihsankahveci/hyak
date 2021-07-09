library(tidyverse)
library(stm)
library(furrr)
plan(multicore)

out <- readRDS(file = "out.rds")
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

#finding the optimal number of K
many_models <- 
  tibble(K = 3:50) %>%
  mutate(topic_model = future_map(K, ~stm(docs, vocab, data = meta,
                                          K = ., 
                                          prevalence = ~holy_days+budget_share+republic+kurdish+civilians+turkish+location+unemployment,  
                                          seed = 57, 
                                          verbose=T,
                                          .options = furrr_options(seed = TRUE))))
#saving the outputs
saveRDS(many_models, "manyModels.rds")

