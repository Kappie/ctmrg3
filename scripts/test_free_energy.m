function test_free_energy
  q = 2;
  chi_values = [4, 16, 32, 50, 70, 100, 200];
  width = 0.1;
  % temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, 10);
  temperatures = Constants.T_crit;
  N_values = [100, 500]

  sim = FixedNSimulation(temperatures, chi_values, N_values, q).run();
  truncation_errors = sim.compute('truncation_error');
  order_parameters = sim.compute('order_parameter');


  markerplot(chi_values, truncation_errors, '--', 'semilogy')
  make_legend(N_values, 'N')



end
