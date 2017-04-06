function plot_corner_energy_gap

  q = 2;
  % temperatures = 2.22:0.005:2.30;
  width = 0.01; number_of_points = 10;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    Constants.T_crit_guess(q) + width, number_of_points);
  chi_values = [4 10 20];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  energy_gaps = sim.compute('corner_energy_gap');
  corr_lengths = 1./energy_gaps

  markerplot(temperatures, corr_lengths, '--')
  make_legend(chi_values, '\chi')
end
