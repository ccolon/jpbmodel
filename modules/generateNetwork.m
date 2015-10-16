%% Generate technology matrix and current matrix

function [W, L] = generateNetwork(rdm_nb_suppliers_on_off, mean_nb_suppliers, nb_extra_suppliers, n, sigma)

    W=zeros(n,n); %input-output matrix, with inputs in rows and outputs in columns
    L=zeros(n,n); %possible other technologies

    % Select the number of suppliers per firm
    if (rdm_nb_suppliers_on_off == 1)
        nb_suppliers = max(min(poissrnd(mean_nb_suppliers,1,n), n-1),1); % draw the number of suppliers per firm. It is poissonian, >= 1 and <= n-1.
    else
        nb_suppliers = mean_nb_suppliers * ones(1,n);
    end
    
    % Compute the number of potential suppliers (current ones + extra ones)
    nb_potential_suppliers = min(nb_suppliers + nb_extra_suppliers, n-1); % draw the number of potential suppliers per firm

    % Each firm select its potential and actual suppliers, and compute the input-ouput coefficient Wij
    for i=1:n
        % Choose potential and actual suppliers
        id_other_firms = randperm(n);           %randomize potential suppliers
        id_other_firms = id_other_firms(id_other_firms~=i); %remove myself
        id_potential_suppliers = id_other_firms(1:nb_potential_suppliers(i));     %choose only nb_potential_suppliers of them to be potential suppliers
        id_suppliers = id_potential_suppliers(1:nb_suppliers(i));     %choose only kappa of them to be actual suppliers
        % Compute the input-ouput coefficient
        L(i,id_potential_suppliers) = 1/nb_suppliers(i) + sigma*randn(1,nb_potential_suppliers(i)); %fixed for the potential technologies (the nb of suppliers remain cst)
        W(i,id_suppliers) = L(i,id_suppliers);
    end

end