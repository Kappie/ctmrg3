function analyze_q5
  % load sim object in variable 'sim'
  load('q5_chi10-100_tol25e-9.mat')

  % Use only final (lowest) tolerance
  sim.tolerances = sim.tolerances(end);
  sim.chi_values = sim.chi_values([2 4 6 8 10]);

  order_parameters = sim.compute('order_parameter');
  entropies = sim.compute('entropy');
  temperatures = sim.temperatures;

  figure
  markerplot(temperatures, entropies, '--')
  title('entropy')
  make_legend(sim.chi_values, '\chi')

  figure
  markerplot(temperatures, order_parameters, '--')
  title('order parameter')
  make_legend(sim.chi_values, '\chi')
end
