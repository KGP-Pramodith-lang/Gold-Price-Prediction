# =====================================================
# GOLD PRICE FORECASTING
# STEP 5: TRAIN-TEST SPLIT & TRADITIONAL TIME-SERIES MODELS
# =====================================================

# 1. Load required library (installs automatically if missing)
if(!require(forecast)) {
  install.packages("forecast")
  library(forecast)
}

# 2. Chronological Data Split (70% Training / 30% Evaluation)
# We MUST use the first 70% of rows sequentially without random sampling[cite: 2].
total_rows <- nrow(gold)
train_size <- floor(0.70 * total_rows)

train_data <- gold[1:train_size, ]
test_data  <- gold[(train_size + 1):total_rows, ]

cat("--- Data Split Verification ---\n")
cat("Training observations:", nrow(train_data), "\n")
cat("Testing observations:", nrow(test_data), "\n")

# 3. Create a Time Series Object for the training set
train_ts <- ts(train_data$Close)

# 4. Model 1: Baseline (Naïve Forecast)
# Predicts tomorrow's price will be exactly today's price[cite: 2].
model_naive <- naive(train_ts)

# 5. Model 2: AR(1) Model (using first-order differencing for stationarity)
# order = c(p, d, q). Using d=1 accounts for the non-stationarity of raw gold prices.
model_ar1 <- Arima(train_ts, order = c(1, 1, 0))

# 6. Model 3: Optimal ARIMA
# auto.arima() rigorously searches for the best combination of p, d, and q terms.
cat("\n--- Running ARIMA Model Selection Process ---\n")
model_arima <- auto.arima(train_ts, 
                          stepwise = FALSE, 
                          approximation = FALSE, 
                          trace = TRUE)

# 7. Review the fitted models
cat("\n--- AR(1) Model Summary ---\n")
print(summary(model_ar1))

cat("\n--- Optimal ARIMA Model Summary ---\n")
print(summary(model_arima))

# 8. Residual Diagnostics (Ljung-Box White Noise Test & Plot)
cat("\n--- ARIMA Residual Diagnostics ---\n")
checkresiduals(model_arima)
