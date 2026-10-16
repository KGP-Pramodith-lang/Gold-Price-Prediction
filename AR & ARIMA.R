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
# We MUST use the first 70% of rows sequentially. No random sampling.
total_rows <- nrow(gold)
train_size <- floor(0.70 * total_rows)

train_data <- gold[1:train_size, ]
test_data  <- gold[(train_size + 1):total_rows, ]

print("--- Data Split Verification ---")
print(paste("Training observations:", nrow(train_data)))
print(paste("Testing observations:", nrow(test_data)))

# 3. Create a Time Series Object for the training set
# We isolate the 'Close' column as the target variable for our models.
train_ts <- ts(train_data$Close)

# 4. Model 1: Baseline (Naïve Forecast)
# Predicts tomorrow's price will be exactly today's price.
# This establishes the baseline MAE and RMSE we must beat.
model_naive <- naive(train_ts)

# 5. Model 2: AR(1) - Autoregressive Model Order 1
# Fits a model relying entirely on the single previous day's price.
# order = c(p, d, q). AR(1) means p=1, d=0, q=0.
model_ar1 <- Arima(train_ts, order = c(1, 0, 0))

# 6. Model 3: ARIMA
# We use auto.arima() to rigorously search for the best combination of 
# Auto-Regressive (p), Differencing (d), and Moving Average (q) terms.
# trace = TRUE lets you watch R compare the AIC scores of different models.
print("--- ARIMA Model Selection Process ---")
model_arima <- auto.arima(train_ts, 
                          stepwise = FALSE, 
                          approximation = FALSE, 
                          trace = TRUE)

# 7. Review the final fitted models
print("--- AR(1) Model Summary ---")
summary(model_ar1)

print("--- Optimal ARIMA Model Summary ---")
summary(model_arima)