function xi = calculate_correlation_length(temperature, chi, tolerance, q, initial_condition)
  SIGNIFICANT_DIGITS = 12;
  sim = FixedToleranceSimulation(temperature, chi, tolerance, q);
  sim.initial_condition = initial_condition;
  sim = sim.run();
  xi = sim.compute('correlation_length');
  xi = round(xi, SIGNIFICANT_DIGITS);
end
