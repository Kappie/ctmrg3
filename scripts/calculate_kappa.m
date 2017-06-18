function calculate_kappa
  q = 2;
  temperature = Constants.T_crit;
  % symmetric boundary T = 2.6 plateaus
  % chi_values = [9 11 13 15 18 21 24 28 33 38 43 49];
  % symmetric boundary T = 2 plateaus
  % chi_values = [10 14 20 28 38 50]
  chi_values = 10:1:66;
  exclude = [13 19 28 29 40 41 42 59];
  % exclude = [13 19 28 29 37 40 41 42 47 52 53 57 59 65 66];

  chi_values = setdiff(chi_values, exclude);

  initial_condition = 'symmetric';
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance, q);
  sim.initial_condition = initial_condition;
  sim = sim.run();

  % corr_lengths = sim.compute('correlation_length');
  free_energies = sim.compute('free_energy');
  diffs = free_energies - Constants.free_energy_per_site(temperature);
  entropies = sim.compute('entropy')

  [slope, intercept] = logfit(chi_values, diffs, 'loglog', 'skipBegin', 0);
end
