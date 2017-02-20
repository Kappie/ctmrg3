function test_clock_model
  q = 4;
  T_start = 1.12; T_end = 1.18;
  number_of_points = 20;
  temperatures = linspace(T_start, T_end, number_of_points);
  chi_values = 2:2:10;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  entropies = sim.compute(Entropy);

  markerplot(temperatures, entropies, '--')
  [max_entropy, index] = max(entropies)
  temperatures(index)

  make_legend(chi_values, '\chi')






end
