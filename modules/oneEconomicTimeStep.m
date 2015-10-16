function [new_prices, new_wage, new_productions, new_hh_wealth] = oneEconomicTimeStep(prices, last_prices, productions, wage, hh_wealth, W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n)

    [discount_rate, interest_rate] = updateEconomicEnvironment(prices, last_prices, beta0, q0, n);

    forecasted_prices = forecastPrices(prices, last_prices, extrapolative_rule);

    [~, labor_needs, input_needs, ~] = planProduction(productions, prices, wage, forecasted_prices, a, b, z, W, discount_rate, production_friction, n);
    
    [new_wage, working_times] = jobMarket(labor_needs, wage, price_friction);
    
    [new_prices, good_flows, final_good_flows, ~] = goodMarkets(productions, prices, input_needs, hh_wealth, price_friction, n);
    
    [~, new_hh_wealth] = payAndTransferMoney(good_flows, final_good_flows, working_times, prices, wage, hh_wealth, interest_rate);
    
    [new_productions] = produce(z, a, b, W, working_times, good_flows, productivity_noise, n);
    
%     % If we rewire, then test other configurations
%     if ifRewiring == 1
%         nbSwitch(t) = 0; %initialize counter of switches
%         for i=1:n
%             currentProfit = anticipatedProfit_t(t,i);
%             testConfig = changeOneSupplier3(W,L,i);
%             [maxRewiredProfit bestRewiredConfig] = computeProfitRewiring(i, testConfig, a, b, z, discount_rate, gamma1, Exp_t_of_P_tp1(t,:), P_t(t,:), h_t(t), X_t(t,:), rho);
%             doChange = comparisonFct(currentProfit, maxRewiredProfit, ifMetropolis, lambda);
%             if (doChange == 1)
%                 W(i,:) = bestRewiredConfig;
%                 nbSwitch(t) = nbSwitch(t) + 1;
%             end
%         end
%     % Redo the calculation with the actual configuration
%     [X_t(t+1,:) anticipatedProfit_t(t,:) l_t(t,:) psi_t(:,:,t) lambda_t(t,:)] = productionPlan(X_t(t,:), h_t(t), P_t(t,:), Exp_t_of_P_tp1(t,:), a, b, z, W, discount_rate, gamma1);
%     end

    

end