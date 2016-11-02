function data_collapse_chi2
  width = 0.0001;
  number_of_points = 10;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit - width/10, number_of_points);
  temperatures = [temperatures linspace(Constants.T_crit + width/10, Constants.T_crit + width, number_of_points)];
  chi_values = [19, 25, 33, 36, 43, 55];
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  correlation_lengths = sim.compute(CorrelationLength);
  order_params = sim.compute(OrderParameter);

  data_collapse(temperatures, chi_values, correlation_lengths, order_params)
end

function data_collapse(temperatures, chi_values, correlation_lengths, order_parameters)
  beta = 1/8; nu = 1;

  x = zeros(numel(temperatures), numel(chi_values));
  scaling_function = zeros(numel(temperatures), numel(chi_values));

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      x(t, c) = Constants.reduced_T(temperatures(t)) * correlation_lengths(t, c)^(1/nu);
      scaling_function(t, c) = order_parameters(t, c) * correlation_lengths(t, c)^(beta/nu);
    end
  end

  markerplot(x, scaling_function, 'none');
  make_legend(chi_values, '\chi')

end
