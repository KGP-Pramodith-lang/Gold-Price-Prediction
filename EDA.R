# =====================================================
# GOLD PRICE FORECASTING
# STEP 3: EXPLORATORY DATA ANALYSIS (EDA)
# =====================================================

# 1. Calculate Daily Returns
# We use logarithmic returns (log returns) rather than simple percentage changes.
# This is the industry standard for financial time series because log returns 
# are symmetric and additive over time.
gold$Return <- c(NA, diff(log(gold$Close)))

# 2. Calculate Volatility (Absolute Returns)
# Taking the absolute value of the returns removes the direction (up or down)
# and isolates the magnitude of the price movement.
gold$Volatility <- abs(gold$Return)

# 3. Setup the plotting area to show one plot at a time clearly
par(mfrow = c(1, 1))

# --- Analysis 1: Gold Price Trend ---
plot(gold$Date, gold$Close, 
     type = "l", 
     col = "darkblue", 
     lwd = 1.5,
     main = "Analysis 1: Daily Gold Closing Prices", 
     xlab = "Date", 
     ylab = "Price (USD)")
grid() # Adds a grid for easier reading

# --- Analysis 2: Price Returns ---
# Wait for the user to view the first plot, or just run this line to see the next one.
plot(gold$Date, gold$Return, 
     type = "l", 
     col = "steelblue", 
     lwd = 1,
     main = "Analysis 2: Daily Log Returns", 
     xlab = "Date", 
     ylab = "Daily Return")
abline(h = 0, col = "red", lty = 2, lwd = 2) # Adds a reference line at zero
grid()

# --- Analysis 3: Volatility Clustering ---
plot(gold$Date, gold$Volatility, 
     type = "l", 
     col = "darkred", 
     lwd = 1,
     main = "Analysis 3: Volatility (Absolute Returns)", 
     xlab = "Date", 
     ylab = "Magnitude of Movement")
grid()