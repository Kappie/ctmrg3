function test_clock_model
  q = 4;
  T_start = 1.13; T_end = 1.15;
  number_of_points = 10;
  temperatures = linspace(T_start, T_end, number_of_points);
  chi_values = [4, 16, 20, 26, 50]
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  entropies = sim.compute('entropy');

  markerplot(temperatures, entropies, '--')
  [max_entropy, index] = max(entropies)
  temperatures(index)

  make_legend(chi_values, '\chi')






end
