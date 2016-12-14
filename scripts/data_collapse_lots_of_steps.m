function data_collapse_lots_of_steps
  beta = 1/8;
  nu = 1;

  chi_values = [2, 4];
  N = 2e4;
  temperature = Constants.T_crit;

  sim = FixedNSimulation(temperature, chi_values, N).run();

  corr_lengths = sim.compute(CorrelationLengthAfun);
  order_params = sim.compute(OrderParameterStrip);

  scaling_function_values = corr_lengths.^(beta/nu) .* order_params;

  markerplot(temperature, scaling_function_values, '--')

end
