function plot_order_parameter
  width = +0.10000;
  temperature = Constants.T_crit + width;
  t = Constants.reduced_Ts(temperature);
  chi_values = 6:1:45;
  tolerance = 1e-12;

  exact_value = Constants.order_parameter(temperature);

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance);
  sim.initial_condition = 'spin-up';
  sim = sim.run();
  order_params = sim.compute(OrderParameterStrip);
  % order_params_strip = sim.compute(OrderParameterStrip);
  % norms = sim.compute(PartitionFunction);
  % unnormalized_order_params = norms .* order_params;

  % correlation_lengths = sim.compute(CorrelationLengthAfun)

  markerplot(chi_values, [abs(order_params - exact_value)], '--', 'semilogy')
  legend({'square lattice', 'strip'}, 'Location', 'best')
  vline(20, '--')
  vline(30, '--')
  vline(40, '--')
  % legend({'norm', 'unnormalized $m$'}, 'Location', 'best')
  xlabel('$\chi$')
  ylabel('$m$')
  title(['$t = ' num2str(t) '$'])
  % diffs = order_params_strip - exact_value;
  % [chi_values' diffs']



  % [order_params' correlation_lengths' chi_values']

end
