library(tidyverse)
library(stm)
library(furrr)
library(future)
library(progressr)
plan(multicore)

print("reading data")
out <- readRDS(file = "out.rds")
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

raw_df = tibble(K = 3:50)

stm_fn <- function(k, p, docs, vocab, meta){
  out <- stm(docs, vocab, data = meta,
             K = k, 
             prevalence = ~holy_days+budget_share+republic+kurdish+civilians+turkish+location+unemployment,  
             seed = 57, verbose=FALSE)
  p()
  return(out)
}

print("running many models")
with_progress({
  p <- progressor(steps = nrow(raw_df))
#finding the optimal number of K
  many_models <- 
    raw_df %>%
    mutate(topic_model = future_map(K, ~stm_fn(k=.,p=p, docs, vocab, meta),
                                    .options = furrr_options(seed = TRUE)))
})

#saving the outputs
print("saving the output")
saveRDS(many_models, "manyModels.rds")

