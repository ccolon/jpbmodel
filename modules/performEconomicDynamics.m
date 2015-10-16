function [prices_ts, wage_ts, productions_ts, hh_wealth_ts] = performEconomicDynamics(Tfinal, prices, last_prices, productions, wage, hh_wealth ...
    , W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n)

    % Create observables
    prices_ts = zeros(Tfinal, n); prices_ts(1,:) = prices;
    wage_ts = zeros(Tfinal, 1); wage_ts(1) = wage;
    productions_ts = zeros(Tfinal, n); productions_ts(1,:) = productions;
    hh_wealth_ts = zeros(Tfinal, 1); hh_wealth_ts(1) = hh_wealth;

    % Iterate economic dynamics module
    for t=1:(Tfinal-1)

        % perform module
        [new_prices, new_wage, new_productions, new_hh_wealth] = oneEconomicTimeStep(prices, last_prices, productions, wage, hh_wealth, W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n);

        % save new variables 
        last_prices = prices;
        prices = new_prices;
        wage = new_wage;
        productions = new_productions;
        hh_wealth = new_hh_wealth;

        % record observables
        prices_ts(t+1,:) = prices;
        wage_ts(t+1) = wage;
        productions_ts(t+1,:) = productions;
        hh_wealth_ts(t+1) = hh_wealth;

    end

end

