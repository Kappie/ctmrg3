function phenomenological_renormalization
  q = 5;
  temperatures = 0.87:0.005:1.03;
  N_values = [20 40 60 100 140];
  max_truncation_error = 1e-5;

  sim = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q);
  sim.chi_start = 100;
  sim = sim.run();
  corr_lengths = sim.compute('correlation_length');

  markerplot(temperatures, corr_lengths ./ N_values, '--')

  make_legend(N_values, 'N')
  xlabel('$T$')
  ylabel('$\xi(N, T) / N$')
  % title('$q = 6$ clock model. $\xi(N, T) = N Q(tN^{1/\nu}) ')

end
