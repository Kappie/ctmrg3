function xi = calculate_correlation_length(temperature, chi, tolerance)
  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
  xi = sim.compute(CorrelationLengthAfun2);
  xi = round(xi, 12);
end
