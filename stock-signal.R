#!/usr/bin/env Rscript

# Load necessary library
library(quantmod)
library(hash)
library(TTR)

# Define the list of stock symbols
stock_symbols <- c("FSLR","AMD","CSIQ","MSFT","AAPL",
                   "GOOGL","AMZN","NEE","BABA","TSLA","PLUG") # SEDO?

# Define the start and end dates for the data
start_date <- as.Date("2020-01-01")
end_date <- Sys.Date()  # Today's date

data <- hash()
