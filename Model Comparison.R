# =====================================================
# GOLD PRICE FORECASTING
# STEP 8: EVALUATION AND MODEL COMPARISON (1-STEP-AHEAD)
# =====================================================

# 1. Target values for evaluation
actuals <- test_data_ml$Target_Close
test_ts_ml <- ts(actuals)

# 2. 1-Step-Ahead Forecasts for all 5 Models
# Baseline
pred_naive <- test_data_ml$Lag1_Close

# Traditional Time-Series Models (1-step-ahead using test set data)
pred_ar1   <- fitted(Arima(test_ts_ml, model = model_ar1))
pred_arima <- fitted(Arima(test_ts_ml, model = model_arima))

# Machine Learning Models
pred_lm <- predict(model_lm, newdata = test_data_ml)
pred_rf <- predict(model_rf, newdata = test_data_ml)

# 3. Metric Calculation Function
calc_metrics <- function(actual, predicted) {
  error <- actual - predicted
  mae  <- mean(abs(error), na.rm = TRUE)
  rmse <- sqrt(mean(error^2, na.rm = TRUE))
  mape <- mean(abs(error / actual), na.rm = TRUE) * 100
  return(c(MAE = mae, RMSE = rmse, MAPE = mape))
}

# 4. Generate Metric Vectors
res_naive <- calc_metrics(actuals, pred_naive)
res_ar1   <- calc_metrics(actuals, pred_ar1)
res_arima <- calc_metrics(actuals, pred_arima)
res_lm    <- calc_metrics(actuals, pred_lm)
res_rf    <- calc_metrics(actuals, pred_rf)

# 5. Build Final Comparison Table
comparison_table <- data.frame(
  Model = c("Baseline (Naïve)", "AR(1)", "ARIMA", "Linear Regression", "Random Forest"),
  rbind(res_naive, res_ar1, res_arima, res_lm, res_rf)
)

rownames(comparison_table) <- NULL
comparison_table$MAE  <- round(comparison_table$MAE, 3)
comparison_table$RMSE <- round(comparison_table$RMSE, 3)
comparison_table$MAPE <- round(comparison_table$MAPE, 3)

cat("--- FINAL MODEL COMPARISON TABLE ---\n")
print(comparison_table)
