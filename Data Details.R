# =====================================================
# GOLD PRICE FORECASTING
# STEP 1: IMPORT AND INSPECT THE DATA
# =====================================================

# 1. Import the CSV file
gold <- read.csv("gold prices.csv",
                 stringsAsFactors = FALSE)

# 2. Clean column names (removes any hidden leading/trailing spaces)
names(gold) <- trimws(names(gold))

# 3. Inspect the dataset structure and top/bottom rows
head(gold)
tail(gold)
dim(gold)
names(gold)
str(gold)

# 4. Statistical summary of numerical columns (mins, maxs, means)
summary(gold)

# 5. Check missing values in each column
colSums(is.na(gold))

# 6. Check for duplicate rows AND duplicate dates specifically
cat("Duplicate rows:", sum(duplicated(gold)), "\n")
if ("Date" %in% names(gold)) {
  cat("Duplicate dates:", sum(duplicated(gold$Date)), "\n")
}

# 7. Check the date range as currently imported
if ("Date" %in% names(gold)) {
  print(head(gold$Date))
  print(tail(gold$Date))
}
