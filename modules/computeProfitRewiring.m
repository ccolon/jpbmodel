%% Given a certain configuration, compute the best anticipated profit of rewiring
% input: production fct parameter (a, b), different configuration Wij,
% price and wage, beta, anticipated prices, z
% output: the best anticipated profits + associated configuration

function [maxRewiredProfit, bestRewiredConfig] = computeProfitRewiring(i, testConfig, a, b, z, beta, gamma1, ExpPrice, Pt, ht, Xt, rho)

if (testConfig == 0)
    maxRewiredProfit = -9999;
    bestRewiredConfig=0;
else
    n = size(testConfig, 2); %nb of firms
    nb = size(testConfig, 1); %nb of configurations
    %select the variables that concern the firm
    z = z(i);
    ExpPrice = ExpPrice(i);
    Xt = Xt(i);
    %compute optimal outputs
    Yopt = (    z * b^b * ht^(-a*b) * (beta*ExpPrice).^b *  prod((ones(nb,1) * Pt).^(-b*(1-a)*testConfig), 2)    ).^(1/(1-b));
    %decide outputs
    Y = (1-gamma1)*(ones(nb,1) * Xt) + gamma1*Yopt;
    %compute amount of inputs necessary
    lambda = beta * ExpPrice * (Y ./ Yopt).^((1-b)/b);
    l = a * b / ht * (lambda .* Y);
    psi = (1-a) * b * testConfig .* ((lambda .* Y) * ones(1,n)) ./ (ones(nb,1) * (Pt));
    %compute antipated profits
    rewiredProfit = beta * ExpPrice * Y - ht * l - psi * Pt' - rho;    
    
    %find the max profit
    [maxRewiredProfit whichConfig] = max(rewiredProfit);
    bestRewiredConfig = testConfig(whichConfig,:);
end

end