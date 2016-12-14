function test_correlation_length_afun2
  temperatures = Constants.T_crit;
  chi_values = [100];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();

  profile on
  corr_2 = sim.compute(CorrelationLengthAfun2);
  corr_3 = sim.compute(CorrelationLengthAfun);
  profile viewer

  markerplot(temperatures, [corr_2 corr_3], '--')
end
