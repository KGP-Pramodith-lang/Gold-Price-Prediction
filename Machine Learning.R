# =====================================================
# GOLD PRICE FORECASTING
# STEP 6: FEATURE ENGINEERING FOR MACHINE LEARNING
# =====================================================

# 1. Load required libraries for data manipulation and rolling metrics
if(!require(dplyr)) { install.packages("dplyr"); library(dplyr) }
if(!require(zoo)) { install.packages("zoo"); library(zoo) }

# 2. Engineer Time-Series Features
# Every feature is strictly lagged by at least 1 day to prevent data leakage.
gold_ml <- gold %>%
  arrange(Date) %>%
  mutate(
    # The Target (Y)
    Target_Close = Close,
    
    # Lagged Features (X)
    Lag1_Close = lag(Close, n = 1),
    Lag2_Close = lag(Close, n = 2),
    Lag1_Volume = lag(Volume, n = 1),
    Lag1_Return = lag(Return, n = 1),
    
    # Rolling Features (X) - wrapped in lag() so today's feature ends yesterday
    MA_5_Day = lag(rollmean(Close, k = 5, fill = NA, align = "right"), n = 1),
    MA_10_Day = lag(rollmean(Close, k = 10, fill = NA, align = "right"), n = 1)
  )

# 3. Handle NA values created by lagging and rolling windows
gold_ml <- na.omit(gold_ml)

# 4. Chronological Train-Test Split (Re-applied for ML dataset)
total_rows_ml <- nrow(gold_ml)
train_size_ml <- floor(0.70 * total_rows_ml)

train_data_ml <- gold_ml[1:train_size_ml, ]
test_data_ml  <- gold_ml[(train_size_ml + 1):total_rows_ml, ]

# 5. Verify the ML-ready dataset
cat("--- Machine Learning Feature Verification (First 3 Rows) ---\n")
print(head(train_data_ml[, c("Date", "Target_Close", "Lag1_Close", "MA_5_Day")], 3))

cat("\n--- Data Split Verification ---\n")
cat("ML Training observations:", nrow(train_data_ml), "\n")
cat("ML Testing observations:", nrow(test_data_ml), "\n")

# =====================================================
# GOLD PRICE FORECASTING
# STEP 7: TRAIN MACHINE LEARNING MODELS
# =====================================================

# 1. Load required library
if(!require(randomForest)) {
  install.packages("randomForest")
  library(randomForest)
}

# 2. Define the exact mathematical formula for our ML models
ml_formula <- Target_Close ~ Lag1_Close + Lag2_Close + Lag1_Volume + Lag1_Return + MA_5_Day + MA_10_Day

# 3. Model 4: Linear Regression
model_lm <- lm(ml_formula, data = train_data_ml)

cat("\n--- Linear Regression Model Summary ---\n")
print(summary(model_lm))

# 4. Model 5: Random Forest
set.seed(2026) 
model_rf <- randomForest(ml_formula, 
                         data = train_data_ml, 
                         ntree = 500, 
                         importance = TRUE)

cat("\n--- Random Forest Model Summary ---\n")
print(model_rf)

# 5. Visualize Feature Importance
varImpPlot(model_rf, 
           main = "Random Forest: Feature Importance",
           col = "darkblue",
           pch = 16)
