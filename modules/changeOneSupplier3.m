%% Generate all possible rewiring for one firm, replacing a randomly chosen supplier
% input: W, L, the firm that rewire
% the supplier to change is chosen randomly among existing suppliers
% output: a matrix with, on each row, a different configuration.


function [testConfig] = changeOneSupplier3(W,L,i)

n = size(W,1);
index = 1:n;
currentConfig = W(i,:);
possibleTechno = L(i,:);
currentSuppliers = index(currentConfig>0);     % identify current suppliers
 
 if size(currentSuppliers,2) == n-1 % if the firm has all other firms as suppliers, no changes
     testConfig = 0;
 else
     supplierToChange =  currentSuppliers(randi(size(currentSuppliers,2)));         % pick one current supplier
     potentialSuppliers = index(currentConfig==0 & possibleTechno>0);                              % identify potential suppliers
     nbPotentialSuppliers = size(potentialSuppliers,2);
     testConfig = zeros(nbPotentialSuppliers, n);
    
     for k=1:nbPotentialSuppliers
         newConfig = currentConfig;
         newConfig(supplierToChange) = 0;
         newConfig(potentialSuppliers(k)) = possibleTechno(potentialSuppliers(k));
         testConfig(k,:) = newConfig;
     end
    
 end

end