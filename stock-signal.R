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

gradient <- function (data) {
  model <- lm( y~x, data=data.frame(x=1:length(data), y=data))
  return (as.numeric(model$coefficients[2]))
}

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

cat("Calculating stats\n")
stats <- hash()
normstats <- hash()
for(symbol in stock_symbols) {
  tryCatch({
    stats[[symbol]] <- data.frame(bb15=BBands(data[[symbol]]$Close, n=15)[,'pctB'])
    normstats[[symbol]] <- data.frame(bb15=scale(stats[[symbol]]$bb15))
    stats[[symbol]]$bb30 <- BBands(data[[symbol]]$Close, n=30)[,'pctB']
    normstats[[symbol]]$bb30 <- scale(stats[[symbol]]$bb30)
    stats[[symbol]]$bb90 <- BBands(data[[symbol]]$Close, n=90)[,'pctB']
    normstats[[symbol]]$bb90 <- scale(stats[[symbol]]$bb90)
    stats[[symbol]]$rsi15 <- RSI(data[[symbol]]$Close, n=15)
    normstats[[symbol]]$rsi15 <- scale(stats[[symbol]]$rsi15)
    stats[[symbol]]$rsi30 <- RSI(data[[symbol]]$Close, n=30)
    normstats[[symbol]]$rsi30 <- scale(stats[[symbol]]$rsi30)
    stats[[symbol]]$rsi90 <- RSI(data[[symbol]]$Close, n=90)
    normstats[[symbol]]$rsi90 <- scale(stats[[symbol]]$rsi90)
    # calculate gradient
    stats[[symbol]]$gradient15 <- gradient(tail(data[[symbol]]$Close, 15))
    normstats[[symbol]]$gradient15 <- stats[[symbol]]$gradient15
    stats[[symbol]]$gradient30 <- gradient(tail(data[[symbol]]$Close, 30))
    normstats[[symbol]]$gradient30 <- stats[[symbol]]$gradient30
    stats[[symbol]]$gradient90 <- gradient(tail(data[[symbol]]$Close, 90))
    normstats[[symbol]]$gradient90 <- stats[[symbol]]$gradient90
  }, error=function(e) {
    cat("Error calculating stats for ", symbol,":", conditionMessage(e), "\n\n")
  })
}

cat("Calculating Scores\n")
# scores are how buy-able the commodity is
scores <- hash()
for(symbol in stock_symbols) {
  tryCatch({
    r <- tail(normstats[[symbol]] ,1)
    score <- (-r$bb15 - r$bb30) +
      (-r$bb30 - r$bb90)/2. +
      (-r$rsi15 - r$rsi30) +
      (-r$rsi30 - r$rsi90)/2.
    score <- score + sign(r$gradient15)*0.25
    score <- score + sign(r$gradient30)*0.5
    score <- score + sign(r$gradient90)*0.125
    scores[[symbol]] <- score
  }, error=function(e) {
    cat("Error calculating stats for ", symbol,":", conditionMessage(e), "\n\n")
  })
}
