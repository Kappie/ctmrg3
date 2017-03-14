function plot_free_energy
  temperature = Constants.T_crit - 0.1;
  N_values = [10:10:500 700:200:1900];
  chi_values = [20];
  q = 2;

  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();
  free_energies = sim.compute('free_energy');
  order_parameters = sim.compute('order_parameter');
  convergences = sim.convergences;
  sim.initial_condition = 'symmetric';
  sim = sim.run()
  free_energies_symmetric = sim.compute('free_energy');
  convergences_symmetric = sim.convergences;
  order_parameters_symmetric = sim.compute('order_parameter')

  diffs = free_energies - free_energies_symmetric;

  figure
  hold on
  markerplot(N_values, -diffs, '--', 'semilogy')
  markerplot(N_values, order_parameters, '--', 'semilogy')
  markerplot(N_values, order_parameters_symmetric, '--', 'semilogy')
  set(gca, 'YScale', 'log')
  legend({'$f_{\mathrm{spin-up}} - f_{\mathrm{symm.}}$', '$m_{\mathrm{spin-up}}$', ...
    '$m_{\mathrm{symm}}$'})
  hold off
  xlabel('$N$')
  title(['Ising model at $T_c + 0.1, \chi = ' num2str(chi_values(1)) '$.'])

end
