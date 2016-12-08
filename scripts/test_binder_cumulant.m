function test_binder_cumulant
  width = 0.1; number_of_points = 9;
  % temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points)
  temperatures = [Constants.T_crit - width]
  chi_values = [4];
  tolerance = 1e-7;

  magnetizations_squared = zeros(numel(temperatures), numel(chi_values));

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      disp(['doing chi = ' num2str(chi_values(c)) ', temp = ' num2str(temperatures(t)) '.'])
      magnetizations_squared(t, c) = binder_cumulant(temperatures(t), chi_values(c), tolerance);
    end
  end

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  sim.initial_condition = 'symmetric';
  order_params = sim.compute(OrderParameter);
  % ratios = magnetizations_squared(:, 1) ./ magnetizations_squared(:, 2)
  % magnetizations_squared

  markerplot(temperatures, [magnetizations_squared order_params], '--');
  legend({'$m^2$', '$m$'})
  ratio = magnetizations_squared ./ (order_params.^2)
  magnetizations_squared
  order_params.^2
end
