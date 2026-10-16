
# =====================================================
# GOLD PRICE FORECASTING
# STEP 1: IMPORT AND INSPECT THE DATA
# =====================================================

# 1. Import the CSV file
gold <- read.csv("gold prices.csv",
                 stringsAsFactors = FALSE)

# 2. Inspect the dataset
head(gold)
tail(gold)

# 3. Check the number of rows and columns
dim(gold)

# 4. Check the column names
names(gold)

# 5. Check the data types
str(gold)

# 6. Check missing values in each column
colSums(is.na(gold))

# 7. Check duplicate records
sum(duplicated(gold))

# 8. Check the date range as currently imported
head(gold$Date)
tail(gold$Date)
