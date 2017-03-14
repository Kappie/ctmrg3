function plot_trunc_error_vs_n
  temperature = Constants.T_crit + 0.01;
  chi_values = [40 80];
  N_values = 200:200:1000;
  q = 2;
  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();

  markerplot(N_values, sim.truncation_errors, '--')


end
