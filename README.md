# Stock Symbol Recommender

## What Is It?

A simple R script for tracking the performance of a specific handful of stocks and recommending symbols in which to invest at a given point in time.

## Installation

```git clone https://github.com/spodzone/R-stock-signal.git```

And then from within an R session, install the required libraries:

```R
> install.packages(c("quantmod","TTR","hash"))
```

## Typical Outputs

```
Downloading
Calculating stats
Calculating Scores

Scores:
   stock      score
7   PLUG  5.7979354
10  MSFT  5.6094165
8    AMD  2.4214893
11  CSIQ  1.2544043
9   AMZN -0.5170767
3   AAPL -0.5399906
4   FSLR -2.9719596
2   TSLA -5.6224164
6  GOOGL -6.0872618
1    NEE -7.1768763
5   BABA -7.5134811
```

## Meaning & Possible Uses

The scores are an arbitrary relative way to compare desirability of buying each stock at the given moment. Symbols appearing toward the top, with positive score, are recently low but with a longer-term positive trend. 
They combine the Bollinger Bands %B and RSI technical indicators alongside prevailing simple linear average gradients, all considered over 15-, 30- and 90-day windows. The indicator numbers are z-scored to normalize whether an indicator is reading high or low in units of standard deviation. 
The full calculation of the scores is transparent in the source code.

One possible trading strategy might be:
* choose / refine the list of stocks
* every week, run the script
* buy a set amount of whatever is in the top two and sell whatever appears as the bottom two


## Disclaimer

No warranty or guarantee is presented. In no way does this purport to trade on your behalf, nor is there any guarantee that the recommendations will lead to profit. What you do with your money is your responsibility.