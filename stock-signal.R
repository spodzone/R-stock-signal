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

# Loop through each stock symbol and download data
cat("Downloading\n")
for(symbol in stock_symbols) {
  tryCatch({
    # Download the stock data
    stock_data <- getSymbols(symbol, src = "yahoo", from = start_date, to = end_date, auto.assign = FALSE)

    data[[symbol]] <- data.frame(tstmp=attr(stock_data, "index"), price=stock_data[,4])
    colnames(data[[symbol]]) <- c("tstmp", "Close")
    # Write the data to a CSV file
    write.csv(stock_data, file = paste0(symbol, "_data.csv"))
  }, error = function(e) {
    cat("Error downloading data for", symbol, ":", conditionMessage(e), "\n\n")
  })
}
