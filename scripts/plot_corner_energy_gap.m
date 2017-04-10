function plot_corner_energy_gap

  q = 2;
  % temperatures = 2.22:0.005:2.30;
  % width = 0.01; number_of_points = 10;
  temperatures = Constants.T_crit;
  chi_values = [4 8 10 14 20 24 28 32 36 40 44 48 52];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  energy_gaps = sim.compute('corner_energy_gap');
  corner_corr_lengths = 1./energy_gaps;
  corr_lengths = sim.compute('correlation_length');

  figure
  markerplot(chi_values, corner_corr_lengths, '--')
  title('Corner correlation length')
  figure
  markerplot(chi_values, corr_lengths, '--')
  title('normal correlation length')
  figure
  markerplot(corr_lengths, corner_corr_lengths, '--', 'loglog')

  % make_legend(chi_values, '\chi')
end
