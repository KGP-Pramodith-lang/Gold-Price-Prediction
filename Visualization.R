# =====================================================
# GOLD PRICE FORECASTING
# STEP 9: VISUAL DIAGNOSTICS & VOLATILITY INVESTIGATION
# =====================================================

# 1. Plot Actual vs. Predicted Prices
# Plotting actuals against Baseline, Linear Regression, and Random Forest
plot(test_data_ml$Date, actuals, 
     type = "l", col = "black", lwd = 2,
     main = "Forecast Comparison: Actual vs. Predictions (Test Set)",
     xlab = "Date", ylab = "Gold Price (USD)",
     ylim = range(c(actuals, pred_lm, pred_naive), na.rm = TRUE))

lines(test_data_ml$Date, pred_naive, col = "gray", lty = 2, lwd = 1.5)
lines(test_data_ml$Date, pred_lm, col = "blue", lwd = 1.5)
lines(test_data_ml$Date, pred_rf, col = "red", lwd = 1.5, lty = 3) 

legend("bottomright", 
       legend = c("Actual Price", "Baseline (Naïve)", "Linear Regression", "Random Forest"),
       col = c("black", "gray", "blue", "red"), 
       lty = c(1, 2, 1, 3), 
       lwd = c(2, 1.5, 1.5, 1.5))

grid()

# 2. Assignment Requirement: Further Investigation (Volatility Regimes)
# Hypothesis: Models are significantly less accurate during high market volatility.

# Calculate the actual daily absolute price swing in the test set
test_volatility <- abs(test_data_ml$Target_Close - test_data_ml$Lag1_Close)

# Define "High Volatility" as the top 20% of price swings
threshold <- quantile(test_volatility, 0.80, na.rm = TRUE)

high_vol_indices <- which(test_volatility >= threshold)
low_vol_indices  <- which(test_volatility < threshold)

# 3. Calculate Linear Regression MAE under different market regimes
mae_high_vol <- mean(abs(actuals[high_vol_indices] - pred_lm[high_vol_indices]), na.rm = TRUE)
mae_low_vol  <- mean(abs(actuals[low_vol_indices] - pred_lm[low_vol_indices]), na.rm = TRUE)

# 4. Display the Investigation Results
cat("\n--- FURTHER INVESTIGATION: IMPACT OF MARKET VOLATILITY ---\n")
cat("Volatility Threshold (Top 20%): Price swing > $", round(threshold, 2), "\n")
cat("Linear Regression MAE on CALM days: $", round(mae_low_vol, 3), "\n")
cat("Linear Regression MAE on VOLATILE days: $", round(mae_high_vol, 3), "\n")

# Calculate performance degradation percentage
degradation <- (mae_high_vol / mae_low_vol) - 1
cat("Model error increases by", round(degradation * 100, 1), "% during volatile market conditions.\n")
