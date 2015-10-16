%% Production plan of the firms

function [target_productions, labor_needs, input_needs, lambda] = planProduction(productions, prices, wage, forecasted_prices, a, b, z, W, discount_rate, production_friction, n)

%Evaluate optimal production
optimal_productions = (    z .* b.^b .* (discount_rate*forecasted_prices).^b * wage^(-a*b) .* prod((ones(n,1) * prices).^(-b*(1-a)*W), 2)'    ).^(1/(1-b));

%Decide production
target_productions = production_friction * productions + (1-production_friction) * optimal_productions;

%Compute the necessay inputs
lambda = discount_rate .* forecasted_prices .* (target_productions ./ optimal_productions).^((1-b)/b);
labor_needs = a .* b ./ wage .* lambda .* target_productions;
input_needs = (1-a) .* b .* W .* ((lambda .* target_productions).' * (prices).^(-1));

%Evaluate anticipated profits
%target_profits = (discount_rate * forecasted_prices .* target_productions) - (wage * labor_needs) - (prices * input_needs');

end