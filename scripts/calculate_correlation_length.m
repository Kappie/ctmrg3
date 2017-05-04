function xi = calculate_correlation_length(temperature, chi, tolerance, q)
  sim = FixedToleranceSimulation(temperature, chi, tolerance, q).run();
  xi = sim.compute('correlation_length');
  xi = round(xi, 12);
end
