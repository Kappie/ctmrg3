function second_eigenvalue_ctm
  width = 0.001; number_of_points = 9;
  temperatures = Util.linspace_around_T_crit(width, number_of_points);
  chi_values = [10, 12, 20, 40];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  second_eigenvalues = arrayfun(@(tensor) tensor.C(2, 2), sim.tensors);

  markerplot(temperatures, second_eigenvalues, '--')
  make_legend(chi_values, '\chi')

end
