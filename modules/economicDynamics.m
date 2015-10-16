%% Model version : no market clearing + rewiring, function
% optimal switch one firm one supplier
function [X_t, P_t, h_t, Excess_t, anticipatedProfit_t, realizedProfit_t, finalCons_t, M_t, l_t, psi_t, W, nbSwitch, whoChanged_t] = modelNMCRv4(Tfinal,ifRewiring, ifMetropolis,lambda,a,b,beta0,q0,z,sigma,q,gamma1,gamma2,W,L,rho,P1, P2, Exp1, h1, h2, X1, X2, Xopt1, Xopt2, lambda1, l1, psi1, M1, exc1)

%Initialize
P_t = [P1 ; P2];
Exp_t_of_P_tp1 = Exp1;
h_t = [h1 h2];
X_t=[X1; X2];
Xopt_t=[Xopt1; Xopt2];
lambda_t=lambda1;
l_t=l1;
psi_t=psi1;
M_t=[M1 M1];
Excess_t=exc1;
n=size(X1,2);
nbSwitch=zeros(Tfinal,1);
anticipatedProfit_t = 0*P1;
realizedProfit_t = anticipatedProfit_t;
finalCons_t = M1./(n*P1);
whoChanged_t = zeros(1,n);

%Iterate
for t=2:(Tfinal)
    
% Current discount rate and interest rate
beta = computeBeta(P_t(t,:), P_t(t-1,:), beta0, q0);
interestRate = beta - 1;

% Productivity are affected by some shocks
%if randi([1 100]) > 99
%  impairedFirm = randi([1 20]);
%  z(impairedFirm) = 0.5;potentialWs
%  t
%end
z=ones(1,n);
%z = productivityShock(z,sigma);

% Firms forecast price
Exp_t_of_P_tp1(t,:) = forecastPrice(q, P_t(t,:), P_t(t-1,:));

% Do production plan for the current wiring
[X_t(t+1,:) anticipatedProfit_t(t,:) l_t(t,:) psi_t(:,:,t) lambda_t(t,:)] = productionPlan(X_t(t,:), h_t(t), P_t(t,:), Exp_t_of_P_tp1(t,:), a, b, z, W, beta, gamma1);

% If we rewire, then test other configurations
if ifRewiring == 1
    nbSwitch(t) = 0; %initialize counter of switches
    for i=1:n
        currentProfit = anticipatedProfit_t(t,i);
        testConfig = changeOneSupplier3(W,L,i);
        [maxRewiredProfit bestRewiredConfig] = computeProfitRewiring(i, testConfig, a, b, z, beta, gamma1, Exp_t_of_P_tp1(t,:), P_t(t,:), h_t(t), X_t(t,:), rho);
        doChange = comparisonFct(currentProfit, maxRewiredProfit, ifMetropolis, lambda);
        if (doChange == 1)
            W(i,:) = bestRewiredConfig;
            nbSwitch(t) = nbSwitch(t) + 1;
        end
    end
% Redo the calculation with the actual configuration
[X_t(t+1,:) anticipatedProfit_t(t,:) l_t(t,:) psi_t(:,:,t) lambda_t(t,:)] = productionPlan(X_t(t,:), h_t(t), P_t(t,:), Exp_t_of_P_tp1(t,:), a, b, z, W, beta, gamma1);
end

% Households and firms go on the market
% 1. Job market: it clears
h_t(t+1) = jobMarketClearing(lambda_t(t,:), X_t(t+1,:), a, b);
% 2. Good markets: on each good market, the price adjusts with friction coefficient gamma2
[P_t(t+1,:), Excess_t(t,:), tradedVolume, actualPsi_t, finalCons_t(t,:)] = goodMarketsNonClearing(P_t(t,:), M_t(t), X_t(t,:), psi_t(:,:,t), gamma2);

% Firms evaluate the profit they actually realized
realizedProfit_t(t,:) = tradedVolume .* P_t(t,:) - h_t(t) .*  l_t(t,:) - P_t(t,:) * actualPsi_t';

% Households evaluate their earning, expenditure and savings
hhIncomeLabor = h_t(t) .*  l_t(t,:); %per firm
hhExpenditure = finalCons_t(t,:) .* P_t(t,:); %per good type
hhSavings = max(0, M_t(t) - sum(hhExpenditure)); %we "max" it to avoid negative savings

% Finally, if firms were rationned, they cannot produce all they wanted. So X_t(t+1,:) need to be readjusted.
X_t(t+1,:) = produce(z, a, b, W,  l_t(t,:), actualPsi_t);

% Households compute wealth
M_t(t+1) = hhSavings^(1+interestRate) + sum(realizedProfit_t(t,:)) + sum(hhIncomeLabor);

% Print that this timestep was done
disp(['time step ', num2str(t), ' is done'])

end


end