function compare_correlation_lengths
  % width = 0.1;
  % number_of_points = 9;
  % temperatures = Util.linspace_around_T_crit(width, number_of_points);
  % temperatures = Util.linspace_around_t(0.01, 3);
  temperatures = Constants.inverse_reduced_Ts([0.1 0.05 0.01])
  % chi_values = [8, 16, 32, 64];
  % chi_values = [2, 4, 6]
  chi_values = [8, 12, 16, 20, 24, 28, 32]
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  corr = sim.compute(CorrelationLength)
  corr2 = sim.compute(CorrelationLength2)
  diffs = Util.relative_error(corr2, corr);

  markerplot(chi_values, diffs, '--', 'semilogy')
  xlabel('$\chi$')
  ylabel('$(\xi_3 - \xi_2) / \xi_2$')
  make_legend(Constants.reduced_Ts(temperatures), 't')
end
