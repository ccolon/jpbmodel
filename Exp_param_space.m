addpath('/user/ccolon/Dropbox/PhD/4. models/jpb/model/modules');

folder = '/home/ccolon/DDlocal/experiment/jpb/param_n2c1/';
last_n_values = 2000;
            
% Repetition over network structure
nb_reps = 20;

% Parameter 1 to explore: production friction
span1 = 0.5;%0:0.1:1;
nb_it1 = length(span1);

% Parameter 2 to explore: price friction
span2 = 0:0.01:1;
nb_it2 = length(span2);

% Observables
fixed_point = zeros(nb_it1, nb_it2, nb_reps);
transient = zeros(nb_it1, nb_it2, nb_reps);
  
% Parameters
[Tfinal, n, fixed_nb_suppliers_on_off, mean_nb_suppliers, nb_extra_suppliers, init_hh_wealth ...
    , a, b, z, beta0, extrapolative_rule, q0, production_friction, price_friction, sigma, productivity_noise ...
    , rewiring, metropolis, lambda, nbSwitchTested, nbRewiringTried, rho] = setParameters(2,1);

%Generate I/O matrix and technology matrix
[W, L] = generateNetwork(fixed_nb_suppliers_on_off, mean_nb_suppliers, nb_extra_suppliers, n, sigma);

% Initial conditions (does not depend on parameter changes)
[productions_eq, prices_eq, wage_eq] = computeEquilibrium(a, b, W, z, init_hh_wealth, beta0, n);
[prices, last_prices, wage, productions, hh_wealth] = setInitConditions(a, b, W, z, init_hh_wealth, beta0, n);
            
for it1=1:nb_it1

    production_friction = span1(it1);

%         fprintf('ITERATION (rep=%i, production_friction=%g)\n',rep, production_friction);

    for it2=1:nb_it2

        price_friction = span2(it2);

        for rep=1:nb_reps
            
%             fprintf('ITERATION (rep=%i, production_friction=%g, price_friction=%g)\n',rep, production_friction, price_friction);

            % Small perturbation
            productions = productions_eq + [(randn(1) * 1e-3 * productions_eq(1)) zeros(1,n-1)];

    %             [fixed_point] = checkFixedPoint(100, prices, last_prices, productions, productions_eq, wage, hh_wealth ...
    %                 , W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n);
    %             
    %             stable_unstable(it1,it2,rep) = fixed_point;

            % Perform economic dynamics
            Tfinal = 10000;
            [prices_ts, wage_ts, productions_ts, hh_wealth_ts] = performEconomicDynamics(Tfinal, prices, last_prices, productions, wage, hh_wealth ...
                , W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n);

    %            % Test whether stable or not
    % %            condition = (mean(wage_ts) - wage)/wage < 1e-3 & std(wage_ts) < 1e-3;
    %             period = 2000;
    %             
    %             conditions_fixed_point = (productions_ts((Tfinal-period+1):Tfinal,:) - ones(period,1) * productions_eq) ./ (ones(period,1) * productions_eq) < 1e-6;
    %             fixed_point(it1,it2,rep) = prod(prod(conditions_fixed_point + 0));
    %             conditions_big_transient = (productions_ts(1:period,:) - ones(period,1) * productions_eq) ./ (ones(period,1) * productions_eq) > 1e-1;
    %             transient(it1,it2,rep) = sum(sum(conditions_big_transient + 0)) > 0;

            centered_productions = productions_ts - ones(Tfinal,1) * productions_eq;
            centered_prices = prices_ts - ones(Tfinal,1) * prices_eq;
            centered_wage = wage_ts - ones(Tfinal,1) * wage_eq;
            centered_hh_wealth = hh_wealth_ts - ones(Tfinal,1) * init_hh_wealth;
            
            prefix = [folder 'simu_' sprintf('%1.2f_%1.2f_%0.3i',production_friction, price_friction, rep) '_'];
            dlmwrite([prefix 'centered_productions.txt'], centered_productions((end-last_n_values+1):end,:));
            dlmwrite([prefix 'centered_prices.txt'], centered_prices((end-last_n_values+1):end,:));
            dlmwrite([prefix 'centered_wage.txt'], centered_wage((end-last_n_values+1):end,:));
            dlmwrite([prefix 'centered_hh_wealth.txt'], centered_hh_wealth((end-last_n_values+1):end,:));
            
        end

    end

end

