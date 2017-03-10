function plot_truncation_error_vs_n
  temperatures = Constants.T_crit;
  chi_values = 10:10:120;
  N_values = [100 1000];
  q = 2;

  sim = FixedNSimulation(temperatures, chi_values, N_values, q);
  sim = sim.run()
  sim.tensors
  truncation_errors = squeeze(arrayfun(@(s) s.truncation_error, sim.tensors))

  markerplot(chi_values, truncation_errors, '--', 'semilogy')
  xlabel('$\chi$')
  ylabel('truncation error')
  make_legend(N_values, 'N')


end
