function [new_prices, good_flows, final_good_flows, excesses] = goodMarkets(productions, prices, input_needs, hh_wealth, price_friction, n)

    % Compute supply of each good
    supply = productions;

    % Compute demand of households for each good (final consumption)
    final_demand = hh_wealth ./ (n .* prices);

    % Compute demand from other firms (intermediary consumption)
    intermediary_demand = sum(input_needs, 1);

    % Compute total demand for each good
    demand = intermediary_demand + final_demand;

    % The price adjusts considering the relative proportion of supply and demand
    excesses = supply - demand;
    resulting_prices = prices - excesses ./ productions;
    new_prices = (1 - price_friction) * resulting_prices + price_friction * prices;

    % Rationing and actual good flows
    rationing = min(1, supply ./ demand);
    good_flows = (ones(n,1) * rationing) .* input_needs;
    final_good_flows = final_demand .* rationing;

end