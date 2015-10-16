% Compute initial conditions, which are the equilibrum conditions cf eq. 22, 23 paper

function [productions_eq, prices_eq, wage_eq] = computeEquilibrium(a, b, W, z, hh_wealth, beta0, n)

    %Compute market equilibrium: demand and supply for good should be balanced.
    %We use the input-output balance relationships, used with value of production = production * price.
    input_output_matrix = beta0 * (1-a) * b * W;
    hh_demand = hh_wealth / n * ones(1,n);
    value_prod_eq = hh_demand / (eye(n) - input_output_matrix);

    %Labour market equilibrium
    wage_eq = a * b * beta0 * sum(value_prod_eq);

    %To decompose the value of production into price and production, we need extra information
    %We use the production function, that we pass to the log
    matX = eye(n) - (1-a) .* b .* W';
    bb = log(z) + ones(1,n) * (b*log(b)  - a*b*log(wage_eq) + b*log(beta0)) + b*log(value_prod_eq) - b*(1-a)*log(value_prod_eq)*W';
    log_productions = bb / matX;
    productions_eq = exp(log_productions);
    prices_eq = value_prod_eq ./ productions_eq;

end