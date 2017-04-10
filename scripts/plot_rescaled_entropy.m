function plot_rescaled_entropy
  q = 6;
  T_start = 0.5;
  T_end = 1.1;
  number_of_points = 10;
  temperatures = linspace(T_start, T_end, number_of_points);
  chi_values = [4, 8, 12, 16, 20, 24, 28, 32];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  entropies = sim.compute('entropy');
  corr_lengths = sim.compute('correlation_length')

  figure
  markerplot(temperatures, entropies./corr_lengths, '--')
  make_legend(chi_values, '\chi')
  % figure
  % markerplot(temperatures, corr_lengths, '--')
end
