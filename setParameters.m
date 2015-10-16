function [Tfinal, n, rdm_nb_suppliers_on_off, mean_nb_suppliers, nb_extra_suppliers, init_hh_wealth ...
    , a, b, z, beta0, extrapolative_rule, q0, production_friction, price_friction, sigma, productivity_noise ...
    , rewiring, metropolis, lambda, nbSwitchTested, nbRewiringTried, rho] = setParameters(n, mean_nb_suppliers)

    % Time horizon
    Tfinal = 10000;

    % Network
%     n = 2;
    rdm_nb_suppliers_on_off = 0; %fixed (0) or random (1)
%     mean_nb_suppliers =1; %average number of suppliers
    nb_extra_suppliers = 1;

    % Initial wealth
    init_hh_wealth = n;

    % Production function
    a = 0.5;
    b = 0.9;
    z = ones(1,n);
    productivity_noise = 0*1e-6;

    % Base discount rate
    beta0 = 1;

    % Anticipation factors
    extrapolative_rule = 0; %extrapolation of price
    q0 = extrapolative_rule; %evaluation of discount rate

    % Friction paramerters
    production_friction = 0.95;
    price_friction = 0.95;

    % Productivity micro-shocks
    sigma=0*1e-2;

    % Rewiring
    rewiring=0;
    metropolis=0;
    lambda=100;
    nbSwitchTested = 2;
    nbRewiringTried = 4;
    rho = 0.03; % the rewiring cost

end