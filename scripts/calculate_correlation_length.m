function xi = calculate_correlation_length(temperature, chi, tolerance)
  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
  xi = sim.compute('correlation_length');
  xi = round(xi, 12);
end
