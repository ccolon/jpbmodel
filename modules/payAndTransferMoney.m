function [profits, new_hh_wealth] = payAndTransferMoney(good_flows, final_good_flows, working_times, prices, wage, hh_wealth, interest_rate)

    % Firms evaluate the profit they actually realized
    volumes_sold = final_good_flows + sum(good_flows);
    profits = volumes_sold .* prices - wage * working_times - prices * good_flows';

    % Households evaluate their earning, expenditure and savings
    hh_labor_income = sum(wage * working_times);
    hh_capital_income = sum(profits);
    hh_expenditure = sum(prices .* final_good_flows);
    new_hh_wealth = hh_wealth^(1+interest_rate) + hh_labor_income + hh_capital_income - hh_expenditure;
    
end