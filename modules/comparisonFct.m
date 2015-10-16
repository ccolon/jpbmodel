%% the choice function, either simple comparison or metropolis


function choice = comparisonFct(baseQty, newQty, ifMetropolis, lambda)

if ifMetropolis == 1
    choice = metropolis(baseQty, newQty, lambda);
else
    choice = newQty > baseQty;
end

end