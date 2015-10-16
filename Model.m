addpath('/user/ccolon/Dropbox/PhD/4. models/jpb/model/modules');

tic
% Parameters
[Tfinal, n, fixed_nb_suppliers_on_off, mean_nb_suppliers, nb_extra_suppliers, init_hh_wealth ...
    , a, b, z, beta0, extrapolative_rule, q0, production_friction, price_friction, sigma, productivity_noise ...
    , rewiring, metropolis, lambda, nbSwitchTested, nbRewiringTried, rho] = setParameters(100,4);

%Generate I/O matrix and technology matrix
[W, L] = generateNetwork(fixed_nb_suppliers_on_off, mean_nb_suppliers, nb_extra_suppliers, n, sigma);

% Compute equlibrium
[productions_eq, prices_eq, wage_eq] = computeEquilibrium(a, b, W, z, init_hh_wealth, beta0, n);

% Initial conditions
% [prices, last_prices, wage, productions, hh_wealth] = setInitConditions(a, b, W, z, init_hh_wealth, beta0, n);

% Initial perturbations
prices = prices_eq ;
last_prices = prices_eq;
wage = wage_eq;
productions = productions_eq + randn(1,1) * 1e-2 .* [1 zeros(1,n-1)];
hh_wealth = init_hh_wealth;

% Set bifurcation parameters
production_friction = 0.8;
price_friction = 0.8;

% Perform economic dynamics
[prices_ts, wage_ts, productions_ts, hh_wealth_ts] = performEconomicDynamics(Tfinal, prices, last_prices, productions, wage, hh_wealth ...
    , W, a, b, z, beta0, q0, extrapolative_rule, production_friction, price_friction, productivity_noise, n);

toc

% Compute exponent
% (productions_ts(2,1) - productions_ts(1,1)) / (productions_ts(1,1) - productions_eq(1))

% Plot output
figure(2); clf;
subplot(2,2,1);
plot(1:Tfinal, prices_ts)
xlabel('Time'); ylabel('Prices');
subplot(2,2,2);
plot(1:Tfinal, wage_ts - wage_eq)
xlabel('Time'); ylabel('Wage');
subplot(2,2,3);
plot(1:Tfinal, productions_ts - ones(Tfinal,1) * productions_eq)
xlabel('Time'); ylabel('Productions');
subplot(2,2,4);
plot(1:Tfinal, hh_wealth_ts)
xlabel('Time'); ylabel('Household wealth');

