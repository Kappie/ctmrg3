function test_clock_model
  q = 4;
  % T_start = 1.13; T_end = 1.15;
  width = 0.005;
  T_start = Constants.T_crit_guess(q) - width; T_end = Constants.T_crit_guess(q) + width;
  number_of_points = 6;
  temperatures = linspace(T_start, T_end, number_of_points);
  chi_values = [4, 16, 26, 50]
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  entropies = sim.compute('entropy');
  energy_gaps = sim.compute('energy_gap');

  markerplot(temperatures, entropies, '--')
  xlabel('$T$')
  ylabel('$S(T, \chi)$')
  title('$q = 4$ clock model')

  make_legend(chi_values, '\chi')






end
