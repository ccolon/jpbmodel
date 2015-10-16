function [fixed_point] = checkFixedPoint(period, prices, last_prices, productions, productions_eq, wage, hh_wealth ...
    , W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n)

    % Create observables
    prices_ts = zeros(period, n); prices_ts(1,:) = prices;
    wage_ts = zeros(period, 1); wage_ts(1) = wage;
    productions_ts = zeros(period, n); productions_ts(1,:) = productions;
    hh_wealth_ts = zeros(period, 1); hh_wealth_ts(1) = hh_wealth;

    max_period = 1000;
    t = 1;
    stop = 0;
    while (t < max_period && stop ==0)
        
        % perform module
        [new_prices, new_wage, new_productions, new_hh_wealth] = oneEconomicTimeStep(prices, last_prices, productions, wage, hh_wealth, W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n);

        % save new variables 
        last_prices = prices;
        prices = new_prices;
        wage = new_wage;
        productions = new_productions;
        hh_wealth = new_hh_wealth;

        % record observables
        prices_ts(mod(t,period)+1,:) = prices;
        wage_ts(mod(t,period)+1) = wage;
        productions_ts(mod(t,period)+1,:) = productions;
        hh_wealth_ts(mod(t,period)+1) = hh_wealth;
        
        % test whether fixed point
        if t >= period
            test = productions_ts - ones(period,1) * productions_eq < 1e-10;
            stop = prod(prod(test + 0));
        end
        t = t + 1;
        
    end
    
    fixed_point = stop;

end

