# =====================================================
# GOLD PRICE FORECASTING
# STEP 2: DATA CLEANING AND PREPARATION
# =====================================================

# 1. Rename 'Close.Last' to 'Close'
names(gold)[names(gold) == "Close.Last"] <- "Close"

# 2. Convert the Date column from character to a proper R Date object
# Assuming your dates are formatted as Month/Day/4-Digit-Year (e.g., "12/31/2023").
gold$Date <- as.Date(gold$Date, format = "%m/%d/%Y")

# 3. Sort chronologically (oldest to newest)
# This is a mandatory step before any time-series analysis or chronological splitting.
gold <- gold[order(gold$Date), ]
rownames(gold) <- 1:nrow(gold) # Reset row indices after sorting

# 4. Clean Volume and Price columns FIRST (Strip commas/dollar signs and convert to numeric)
# This must happen before any calculations (like medians) are performed on them.
if ("Volume" %in% names(gold)) {
  gold$Volume <- as.numeric(gsub("[\\$,]", "", as.character(gold$Volume)))
}

price_cols <- c("Close", "Open", "High", "Low")
existing_price_cols <- price_cols[price_cols %in% names(gold)]
gold[existing_price_cols] <- lapply(gold[existing_price_cols], function(x) {
  as.numeric(gsub("[\\$,]", "", as.character(x)))
})

# 5. Handle missing Volume values NOW that it is fully numeric
if ("Volume" %in% names(gold)) {
  median_volume <- median(gold$Volume, na.rm = TRUE)
  gold$Volume[is.na(gold$Volume)] <- median_volume
}

# 6. Verify the clean dataset
print("--- First 6 rows (Chronological Check) ---")
head(gold)

print("--- Data Structure Check ---")
str(gold)

print("--- Missing Values Check ---")
colSums(is.na(gold))

# =====================================================
# HANDLE MISSING VALUES & FINAL PREPARATION
# =====================================================

# 1. Impute missing Volume values with the median volume
median_volume <- median(gold$Volume, na.rm = TRUE)
gold$Volume[is.na(gold$Volume)] <- median_volume

# 2. Verify that there are zero missing values left across the entire dataset
cat("--- Missing Values After Imputation ---\n")
print(colSums(is.na(gold)))

# 3. Save the fully cleaned dataset for downstream scripts
write.csv(gold, "cleaned_gold_prices.csv", row.names = FALSE)
cat("\nSuccess! Cleaned dataset saved as 'cleaned_gold_prices.csv'.\n")
