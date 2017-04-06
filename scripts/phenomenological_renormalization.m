function phenomenological_renormalization
  q = 2;
  % temperatures = 2.22:0.005:2.30;
  width = 0.01; number_of_points = 10;
  temperatures = linspace(Constants.T_crit_guess(q) - width, Constants.T_crit_guess(q) + width, number_of_points)
  N_values = [140 400 650 1100];
  max_truncation_error = 1e-5;

  sim = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q);
  sim.chi_start = 20;
  sim = sim.run();
  % corr_lengths = sim.compute('correlation_length');
  corr_lengths = 1 ./ sim.compute('corner_energy_gap');

  markerplot(temperatures, corr_lengths ./ N_values, '--')

  make_legend(N_values, 'N')
  xlabel('$T$')
  ylabel('$\xi(N, T) / N$')
  % title('$q = 6$ clock model. $\xi(N, T) = N Q(tN^{1/\nu}) ')

end
