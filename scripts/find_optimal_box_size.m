function find_optimal_box_size
  chi_benchmark = 32;
  chi = 24;
  chi_values = [chi chi_benchmark];
  width = 0.001; number_of_points = 19;
  temperatures_array = linspace(Constants.T_crit - width, Constants.T_crit, number_of_points);
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures_array, chi_values, tolerance).run();
  order_params_array = sim.compute(OrderParameter);

  temperatures = containers.Map('keyType', 'double', 'valueType', 'any');
  order_parameters = containers.Map('keyType', 'double', 'valueType', 'any');

  for c = 1:numel(chi_values)
    chi = chi_values(c);
    temperatures(chi) = temperatures_array;
    order_parameters(chi) = order_params_array(:, c);
  end

  optimize_box_size(temperatures, chi_values, order_parameters)



end
