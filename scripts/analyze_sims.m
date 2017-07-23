function analyze_sims
  load('q6_all_temperatures_chi20-80.mat', 'sims')

  figure
  hold on
  for i = 1:numel(sims)
    sim = sims{i};
    order_params = sim.compute('order_parameter');
    entropies = sim.compute('entropy');
    temperatures = sim.temperatures;
    if sim.chi_values == 40
      indices_to_plot = temperatures ~= 0.8625;
      temperatures = temperatures(indices_to_plot);
      order_params = order_params(indices_to_plot);
      entropies = entropies(indices_to_plot);
    end

    markerplot(temperatures, entropies, '--')
  end

  hold off

  make_legend([20 40 60 80], '\chi')
end
