function debug_order_param_strip
  temperature = Constants.T_crit + 0.01;
  chi = 14;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();
  sim.compute(CorrelationLengthAfun)
end
