# Gold Price Forecasting R Project
An end-to-end time-series analysis and machine learning framework built in R to forecast daily gold closing prices (2013–2023).

## Project Overview
This repository contains the complete analytical pipeline evaluating traditional econometric time-series models (Naïve Baseline, AR(1), ARIMA) alongside machine learning models (Linear Regression, Random Forest). The analysis includes feature engineering, stationarity testing, model comparison (MAE, RMSE, MAPE), and a volatility regime investigation.

## Repository Structure

```
├── gold prices.csv               # Raw input dataset
├── cleaned_gold_prices.csv       # Preprocessed chronologically sorted dataset
├── main_pipeline.R               # Complete executable R script (Steps 1 to 9)
├── Gold_Price_Forecasting_Report.md  # Detailed project report
└── README.md                     # Project documentation
```

## Installation & Setup

### Prerequisites

- **R Environment:** R version 4.4.0 or higher
- **IDE:** RStudio (Recommended)

### Required R Packages
The analysis relies on the following R packages, which are automatically checked and installed during script execution:

```
install.packages(c("tseries", "forecast", "dplyr", "zoo", "randomForest", "graphics"))
```

## How to Run the Analysis

1. Place `gold prices.csv` in your working directory.
2. Open `main_pipeline.R` (or execute the steps in sequence in your R console).
3. Run the script from Step 1 through Step 9:

- **Steps 1–3:** Cleaning, sorting, missing value imputation, and log return calculation.
- **Step 4:** ADF stationarity testing and ACF/PACF generation.
- **Steps 5–7:** Train/test splitting, ARIMA fitting, feature engineering, and ML model training.
- **Steps 8–9:** Model evaluation table generation and volatility regime testing.

## Evaluation Results Summary
Model

Type

Features Used

Key Evaluation Metrics

**Naïve Baseline**

Benchmark

$P_{t-1}$

MAE, RMSE, MAPE

**AR(1)**

Econometric

Differenced Lags

MAE, RMSE, MAPE

**ARIMA**

Econometric

$(p, d, q)$ auto-selected

MAE, RMSE, MAPE

**Linear Regression**

ML

Lagged Prices, Volume, MAs

MAE, RMSE, MAPE

**Random Forest**

ML

Non-linear ensemble

MAE, RMSE, MAPE

## Key Features

- **Strict Temporal Integrity:** Chronological 70/30 train-test split preventing data leakage.
- **Leakage-Free Features:** Rolling metrics ($\text{MA}_5$, $\text{MA}_{10}$) strictly lagged by 1 day.
- **Advanced Investigation:** Empirical comparison of model error rates between calm trading periods and high-volatility market shocks.
