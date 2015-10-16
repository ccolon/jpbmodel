function [new_wage, working_times] = jobMarket(labor_needs, wage, price_friction)

    total_labor_demand = sum(labor_needs);
    total_labor_offer = 1;
    resulting_wage = (total_labor_demand / total_labor_offer) * wage;
    new_wage = (1 - price_friction) * resulting_wage + price_friction * wage;

    job_rationing = min(1, total_labor_offer ./ total_labor_demand);
    working_times = job_rationing * labor_needs;

end