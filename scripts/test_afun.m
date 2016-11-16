function test_afun
  temperature = Constants.T_crit + 0;
  chi = 64;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperature, chi, tolerance).run();

  profile on
  sim.compute(CorrelationLengthAfun)
  sim.compute(CorrelationLength)
  profile viewer
end
