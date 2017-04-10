function phenomenological_renormalization
  % q = 2;
  % q = 5;
  % temperatures = 0.87:0.005:1.03;
  % N_values = [20 40 60 100 140];
  % width = 0.01; number_of_points = 10;
  % temperatures = linspace(Constants.T_crit_guess(q) - width, ...
  %   Constants.T_crit_guess(q) + width, number_of_points)
  % N_values = [140 400 650 1100];

  q = 6;
  N_values = 20:20:60;
  temperatures = 0.6:0.02:1.1;
  max_truncation_error = 1e-5;

  sim = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q);
  sim.chi_start = 100;
  sim = sim.run();
  % corr_lengths = sim.compute('correlation_length');
  corr_lengths = 1 ./ sim.compute('corner_energy_gap');
  % entropies = sim.compute('entropy')

  markerplot(temperatures, corr_lengths ./ N_values, '--')

  make_legend(N_values, 'N')
  xlabel('$T$')
  ylabel('$\xi(N, T) / N$')
  % title('$q = 6$ clock model. $\xi(N, T) = N Q(tN^{1/\nu}) ')

end
