function xi = calculate_correlation_length(temperature, chi, tolerance)
  if temperature < 0
    xi = 0;
  elseif temperature > 20
    error('hou maar op')
  else
    sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
    xi = sim.compute(CorrelationLengthAfun);
    xi = round(xi, 8);
  end
end
