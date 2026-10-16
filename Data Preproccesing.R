# =====================================================
# GOLD PRICE FORECASTING
# STEP 2: DATA CLEANING AND PREPARATION
# =====================================================

# 1. Rename 'Close.Last' to 'Close'
# 'read.csv' converted the slash in 'Close/Last' to a dot. Let's fix that.
names(gold)[names(gold) == "Close.Last"] <- "Close"

# 2. Convert the Date column from character to a proper R Date object
# Assuming your dates are formatted as Month/Day/4-Digit-Year (e.g., "12/31/2023").
# If your CSV uses 2-digit years, change "%Y" to "%y".
gold$Date <- as.Date(gold$Date, format = "%m/%d/%Y")

# 3. Sort chronologically (oldest to newest)
# This is a mandatory step before any time-series analysis or chronological splitting.
gold <- gold[order(gold$Date), ]

# 4. Handle missing Volume values
# We have 28 missing volumes. We DO NOT want to delete these rows because 
# they contain valid 'Close' prices (our target variable). 
# We will impute (fill) them using the median volume of the dataset.
median_volume <- median(gold$Volume, na.rm = TRUE)
gold$Volume[is.na(gold$Volume)] <- median_volume

# Strip commas and convert Volume to numeric right at the start
gold$Volume <- as.numeric(gsub(",", "", gold$Volume))

# 5. Strip out any potential dollar signs or commas from price columns (if applicable)
# Often, financial CSVs import prices as characters if they contain "$" or ",".
# This forces them to be numeric just in case.
price_cols <- c("Close", "Open", "High", "Low")
gold[price_cols] <- lapply(gold[price_cols], function(x) {
  as.numeric(gsub("[\\$,]", "", x))
})

# 6. Verify the clean dataset
print("--- First 6 rows (Chronological Check) ---")
head(gold)

print("--- Data Structure Check ---")
str(gold)

print("--- Missing Values Check ---")
colSums(is.na(gold))
