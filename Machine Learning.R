# =====================================================
# GOLD PRICE FORECASTING
# STEP 6: FEATURE ENGINEERING FOR MACHINE LEARNING
# =====================================================

# 1. Load required libraries for data manipulation and rolling metrics
if(!require(dplyr)) { install.packages("dplyr"); library(dplyr) }
if(!require(zoo)) { install.packages("zoo"); library(zoo) }

# 2. Engineer Time-Series Features
# We use dplyr to construct new columns. Every feature MUST be lagged by at least 1 day.
gold_ml <- gold %>%
  arrange(Date) %>%
  mutate(
    # The Target (Y): What we are trying to predict today
    Target_Close = Close,
    
    # Lagged Features (X): What happened yesterday and the day before
    Lag1_Close = lag(Close, n = 1),
    Lag2_Close = lag(Close, n = 2),
    Lag1_Volume = lag(Volume, n = 1),
    Lag1_Return = lag(Return, n = 1),
    
    # Rolling Features (X): The trend leading up to yesterday
    # rollmean with align="right" calculates the 5-day average including the current day.
    # We MUST wrap it in lag() so today's feature is the 5-day average ending yesterday.
    MA_5_Day = lag(rollmean(Close, k = 5, fill = NA, align = "right"), n = 1),
    MA_10_Day = lag(rollmean(Close, k = 10, fill = NA, align = "right"), n = 1)
  )

# 3. Handle NA values created by lagging
# The first 10 rows will have NA values because you cannot calculate a 10-day 
# moving average on day 5, nor can you fetch yesterday's price on day 1.
gold_ml <- na.omit(gold_ml)

# 4. Chronological Train-Test Split (Re-applied)
# We must re-split because removing the first 10 rows slightly changed the row count.
total_rows_ml <- nrow(gold_ml)
train_size_ml <- floor(0.70 * total_rows_ml)

train_data_ml <- gold_ml[1:train_size_ml, ]
test_data_ml  <- gold_ml[(train_size_ml + 1):total_rows_ml, ]

# 5. Verify the ML-ready dataset
print("--- Machine Learning Feature Verification (First 3 Rows) ---")
head(train_data_ml[, c("Date", "Target_Close", "Lag1_Close", "MA_5_Day")], 3)

print("--- Data Split Verification ---")
print(paste("ML Training observations:", nrow(train_data_ml)))
print(paste("ML Testing observations:", nrow(test_data_ml)))

#---------------------------------------------------------------------------------------------

# =====================================================
# GOLD PRICE FORECASTING
# STEP 7: TRAIN MACHINE LEARNING MODELS
# =====================================================

# 1. Load required library (installs automatically if missing)
if(!require(randomForest)) {
  install.packages("randomForest")
  library(randomForest)
}

# 2. Define the exact mathematical formula for our ML models
# Target variable on the left of the tilde (~), features on the right separated by (+)
ml_formula <- Target_Close ~ Lag1_Close + Lag2_Close + Lag1_Volume + Lag1_Return + MA_5_Day + MA_10_Day

# 3. Model 4: Linear Regression
# Fits a straight line attempting to map the relationship between features and the target.
model_lm <- lm(ml_formula, data = train_data_ml)

print("--- Linear Regression Model Summary ---")
summary(model_lm)

# 4. Model 5: Random Forest
# Fits hundreds of decision trees to capture non-linear relationships and complex interactions.
# We MUST set a seed before running algorithms that rely on random sampling.
set.seed(2026) 
model_rf <- randomForest(ml_formula, 
                         data = train_data_ml, 
                         ntree = 500,        # Number of trees to grow
                         importance = TRUE)  # Calculate which features matter most

print("--- Random Forest Model Summary ---")
print(model_rf)

# 5. Visualize Feature Importance from the Random Forest
# This plot shows how much the model's accuracy drops if a specific feature is removed.
varImpPlot(model_rf, 
           main = "Random Forest: Feature Importance",
           col = "darkblue",
           pch = 16)