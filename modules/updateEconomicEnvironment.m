function [discount_rate, interest_rate] = updateEconomicEnvironment(prices, last_prices, beta0, q0, n)

    % Discount rate
    discount_rate = beta0 * ( prod(prices ./ last_prices)^(1/n) )^(-q0);
    
    % Interest rate
    interest_rate = discount_rate - 1;

end