function corr_lengths = correlation_lengths(obj)
  corr_lengths = zeros(1, numel(obj.chi_values));

  for c = 1:numel(obj.chi_values)
    sim = FixedToleranceSimulation(Constants.T_crit_guess(obj.q), obj.chi_values(c), 1e-7, obj.q).run();
    corr_lengths(c) = sim.compute('correlation_length');
  end
end