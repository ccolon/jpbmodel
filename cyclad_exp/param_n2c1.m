addpath('/home/ccolon/jpb/jpbmodel/modules');
addpath('/home/ccolon/jpb/jpbmodel/');

folder = '/data/ccolon/param_n2c1/';
last_n_values = 1000;
            
% Repetition over network structure
nb_reps = 10;

% Parameter 1 to explore: production friction
span1 = 0:0.01:1;
nb_it1 = length(span1);

% Parameter 2 to explore: price friction
span2 = 0:0.01:1;
nb_it2 = length(span2);

% Observables
av_mean_centered_productions = zeros(nb_it1, nb_it2, nb_reps);
av_sd_centered_productions = zeros(nb_it1, nb_it2, nb_reps);
av_mean_centered_prices = zeros(nb_it1, nb_it2, nb_reps);
av_sd_centered_prices = zeros(nb_it1, nb_it2, nb_reps);
mean_centered_wage = zeros(nb_it1, nb_it2, nb_reps);
sd_centered_wage = zeros(nb_it1, nb_it2, nb_reps);
mean_centered_hh_wealth = zeros(nb_it1, nb_it2, nb_reps);
sd_centered_hh_wealth = zeros(nb_it1, nb_it2, nb_reps);
  
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
            
            av_mean_centered_productions(it1, it2, rep) = mean(mean(centered_productions));
            av_sd_centered_productions(it1, it2, rep) = mean(std(centered_productions));
            av_mean_centered_prices(it1, it2, rep) = mean(mean(centered_prices));
            av_sd_centered_prices(it1, it2, rep) = mean(std(centered_prices));
            mean_centered_wage(it1, it2, rep) = mean(centered_wage);
            sd_centered_wage(it1, it2, rep) = std(centered_wage);
            mean_centered_hh_wealth(it1, it2, rep) = mean(centered_hh_wealth);
            sd_centered_hh_wealth(it1, it2, rep) = std(centered_hh_wealth);
            
        end

    end

end

prefix = [folder 'simu_' sprintf('%0.3i_%0.3i_%0.3i',nb_it1, nb_it2, nb_reps) '_'];
dlmwrite([prefix 'av_mean_centered_productions.txt'], eliminateComplexNumber(av_mean_centered_productions));
dlmwrite([prefix 'av_sd_centered_productions.txt'], eliminateComplexNumber(av_sd_centered_productions));
dlmwrite([prefix 'av_mean_centered_prices.txt'], eliminateComplexNumber(av_mean_centered_prices));
dlmwrite([prefix 'av_sd_centered_prices.txt'], eliminateComplexNumber(av_sd_centered_prices));
dlmwrite([prefix 'mean_centered_wage.txt'], eliminateComplexNumber(mean_centered_wage));
dlmwrite([prefix 'sd_centered_wage.txt'], eliminateComplexNumber(sd_centered_wage));
dlmwrite([prefix 'mean_centered_hh_wealth.txt'], eliminateComplexNumber(mean_centered_hh_wealth));
dlmwrite([prefix 'sd_centered_hh_wealth.txt'], eliminateComplexNumber(sd_centered_hh_wealth));
