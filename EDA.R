library(tidyverse)   # For data manipulation and ggplot2 visualizations
library(skimr)       # For comprehensive summary statistics
library(lubridate)   # For date parsing and manipulation
library(corrplot)    # For correlation matrix visualizations
library(DataExplorer)# For automated EDA reports

# ==============================================================================
# 2. Load the Dataset
# ==============================================================================
gold_data <- read_csv("gold prices.csv")

# ==============================================================================
# 3. Initial Data Inspection
# ==============================================================================
# View the first and last few rows
head(gold_data)
tail(gold_data)

# Check the structure of the dataset (data types and preview of values)
glimpse(gold_data)

# Generate a comprehensive statistical summary of all columns
skim(gold_data)

# Check for missing values in each column
colSums(is.na(gold_data))

# ==============================================================================
# 4. Data Cleaning & Transformation
# ==============================================================================
# Note: Adjust column names below based on your exact CSV headers (e.g., "Date", "Close")
gold_data_clean <- gold_data %>%
  # Standardize column names to lowercase and replace spaces with underscores
  rename_with(~ tolower(gsub(" ", "_", .x))) %>%
  # Convert the date column to Date format (assuming it is named 'date' and in YYYY-MM-DD format)
  # If it is DD-MM-YYYY, use dmy() instead of ymd()
  mutate(date = ymd(date)) %>%
  # Remove rows with missing date or target price values
  drop_na(date)

# Verify the changes
str(gold_data_clean)

# ==============================================================================
# 5. Univariate Analysis (Distributions & Outliers)
# ==============================================================================
# Histogram of the closing price (assuming a column named 'close' or 'price')
ggplot(gold_data_clean, aes(x = close)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "black", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Gold Prices",
       x = "Price",
       y = "Frequency")

# Boxplot to identify potential outliers in price
ggplot(gold_data_clean, aes(y = close)) +
  geom_boxplot(fill = "gold", color = "black") +
  theme_minimal() +
  labs(title = "Boxplot of Gold Prices (Outlier Detection)",
       y = "Price")

# ==============================================================================
# 6. Time Series & Trend Analysis
# ==============================================================================
# Line plot showing the trend of gold prices over time
ggplot(gold_data_clean, aes(x = date, y = close)) +
  geom_line(color = "darkorange", linewidth = 0.8) +
  theme_minimal() +
  labs(title = "Gold Price Trend Over Time",
       x = "Date",
       y = "Closing Price") +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ==============================================================================
# 7. Bivariate & Correlation Analysis
# ==============================================================================
# Filter out only numerical columns for correlation analysis
numeric_cols <- gold_data_clean %>% select(where(is.numeric))

# Calculate the correlation matrix
cor_matrix <- cor(numeric_cols, use = "complete.obs")

# Plot the correlation matrix
corrplot(cor_matrix, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black",
         title = "Correlation Matrix of Numerical Variables", 
         mar = c(0,0,1,0))

# ==============================================================================
# 8. Automated EDA Report (Optional)
# ==============================================================================
# Generate a full HTML report with distributions, correlations, and PCA
create_report(gold_data_clean, y = "close")