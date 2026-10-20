# =====================================================
# GOLD PRICE FORECASTING
# STEP 4: STATISTICAL ANALYSIS (STATIONARITY & AUTOCORRELATION)
# =====================================================

# 1. Load required library (installs automatically if missing)
if(!require(tseries)) {
  install.packages("tseries")
  library(tseries)
}

# 2. Augmented Dickey-Fuller (ADF) Test on Raw Prices
# Null Hypothesis (H0): The series is non-stationary (has a unit root).
# We expect a high p-value here, meaning we cannot reject H0.
print("--- ADF Test: Raw Closing Prices ---")
adf.test(gold$Close)

# 3. Augmented Dickey-Fuller (ADF) Test on Differenced Data (Returns)
# We must remove the NA value in the first row created during Step 3.
# We expect a low p-value (< 0.05), meaning the differenced series is stationary.
print("--- ADF Test: Daily Returns (Differenced Log Prices) ---")
clean_returns <- na.omit(gold$Return)
adf.test(clean_returns)

# 4. Set up plotting area for ACF and PACF comparisons
par(mfrow = c(2, 2)) # 2x2 grid for 4 plots

# --- Autocorrelation Function (ACF) ---
# Shows correlation between current price and past prices (lags)
acf(gold$Close, main = "ACF: Raw Prices (Non-Stationary)", lag.max = 30)
acf(clean_returns, main = "ACF: Returns (Stationary)", lag.max = 30)

# --- Partial Autocorrelation Function (PACF) ---
# Shows correlation at a specific lag, isolating out the effects of shorter lags
pacf(gold$Close, main = "PACF: Raw Prices", lag.max = 30)
pacf(clean_returns, main = "PACF: Returns", lag.max = 30)

# Reset plot area to default
par(mfrow = c(1, 1))
