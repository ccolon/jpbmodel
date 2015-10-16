function forecasted_prices = forecastPrices(prices, last_prices, extrapolative_rule)

  forecasted_prices = prices + extrapolative_rule * (prices - last_prices);
  
end