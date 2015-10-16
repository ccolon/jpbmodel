%% Produce
function [new_productions] = produce(z, a, b, W, working_times, good_flows, productivity_noise, n)

    productivity = z + productivity_noise * randn(1,n);
    
    WW = W; WW(WW==0) = 1; % so that I can divide by W. No consequence since the corresponding flow of goods will be 0.
    new_productions = productivity .* (working_times ./ a ).^(a.*b) .* prod( ( good_flows ./ ((1-a).*WW) ).^(b.*(1-a).*W) , 2)';

end