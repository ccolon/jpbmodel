% Compute initial conditions, which are the equilibrum conditions cf eq. 22, 23 paper

function [production_eq, price_eq, wage_eq] = computeEquilibrium(a,b,W,z,M, beta0, n)

    %Compute market equilibrium: demand and supply for good should be balanced.
    %We get Veq=Xeq.*Peq
    matV = eye(n) - beta0 * (1-a) * b * W;
    bV = M/n * ones(1,n);
    Veq = bV / matV;

    %Labour market equilibrium
    wage_eq = a * b * beta0 * sum(Veq);

    %To distinguish Peq and Xeq, we need the production function, that we pass to the log
    matX = eye(n) - (1-a) .* b .* W';
    bb = log(z) + ones(1,n) * (b*log(b)  - a*b*log(heq) + b*log(beta0)) + b*log(Veq) - b*(1-a)*log(Veq)*W';
    logXeq = bb / matX;
    production_eq = exp(logXeq);
    price_eq = Veq./Xeq;

end