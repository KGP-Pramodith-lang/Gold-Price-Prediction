# Save the optimal AR(1) model to a file in your working directory
saveRDS(model_ar1, file = "best_gold_ar1_model.rds")

# To load and use it in a future R session, run:
# loaded_model <- readRDS("best_gold_ar1_model.rds")
