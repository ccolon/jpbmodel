% Plotting parameters
font_size = 12;

% Plot
figure(1); clf;
toplot = fixed_point';
hmain = contourf(toplot, 0:1, 'LineStyle', 'none');
hbar = colorbar;
tick_interval = 0.2;
nb_intervals = 1 / tick_interval;
set(gca,'XTick',1:floor(nb_it1 / nb_intervals):nb_it1, 'XTickLabel', 0:tick_interval:1, 'YTick', 1:floor(nb_it2 / nb_intervals):nb_it2, 'YTickLabel', 0:tick_interval:1, 'TickLength',[0 0], 'FontSize', font_size');
bar_scale = 0:1;
set(hbar, 'YTick', bar_scale, 'FontSize', font_size');
xlabel('Production friction', 'FontSize', font_size');
ylabel('Price friction', 'FontSize', font_size');

