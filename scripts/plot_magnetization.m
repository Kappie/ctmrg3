function plot_magnetization
  temperatures = Constants.T_crit + [0.01];
  % chi_values = [4 8 12 16 20 24 28 32];
  chi_values = 4;
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  magnetizations = sim.compute(Magnetization)


end
