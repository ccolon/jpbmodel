function [prices, last_prices, wage, productions, hh_wealth] = setInitConditions(a, b, W, z, init_hh_wealth, beta0, n)

    hh_wealth = init_hh_wealth;
    
    % Initial conditions are the equilibrium conditions
    [productions_eq, prices_eq, wage_eq] = computeEquilibrium(a, b, W, z, hh_wealth, beta0, n);
    
    prices = prices_eq;
    last_prices = prices_eq;
    wage = wage_eq;
    productions = productions_eq;

end