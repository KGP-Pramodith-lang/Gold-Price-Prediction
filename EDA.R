# =====================================================
# GOLD PRICE FORECASTING
# STEP 3: EXPLORATORY DATA ANALYSIS (EDA)
# =====================================================

# 1. Calculate Daily Returns
# Log returns are standard because they are symmetric and additive over time.
gold$Return <- c(NA, diff(log(gold$Close)))

# 2. Calculate Volatility (Absolute Returns)
# Isolates the magnitude of price movements, stripping out direction.
gold$Volatility <- abs(gold$Return)

# 3. Setup a multi-panel plotting layout (3 rows, 1 column)
par(mfrow = c(3, 1), mar = c(3, 4, 2, 1))

# --- Plot 1: Gold Price Trend ---
plot(gold$Date, gold$Close, 
     type = "l", 
     col = "darkblue", 
     lwd = 1.2,
     main = "Gold Closing Prices", 
     xlab = "", 
     ylab = "Price (USD)")
grid()

# --- Plot 2: Daily Log Returns ---
plot(gold$Date, gold$Return, 
     type = "l", 
     col = "steelblue", 
     lwd = 0.8,
     main = "Daily Log Returns", 
     xlab = "", 
     ylab = "Log Return")
abline(h = 0, col = "red", lty = 2, lwd = 1.5)
grid()

# --- Plot 3: Volatility Clustering ---
plot(gold$Date, gold$Volatility, 
     type = "l", 
     col = "darkred", 
     lwd = 0.8,
     main = "Volatility (Absolute Returns)", 
     xlab = "Date", 
     ylab = "Magnitude")
grid()

# Reset plotting parameters back to default (1x1)
par(mfrow = c(1, 1))

# 4. Remove the initial NA row created by the lag in returns for subsequent modeling
gold_eda <- na.omit(gold)

# 5. Quick Statistical Summary of Returns
cat("\n--- Summary of Daily Log Returns ---\n")
print(summary(gold_eda$Return))
